public static Map getMonitor(String ip, String username, String pass){
        String cmd = "export TERM=linux;res=\"\"\n" +
                formatMonitorCmd("load_average", "`uptime | awk '{print $NF}'`")+
                formatMonitorCmd("processor", "`grep -c 'model name' /proc/cpuinfo`")+
                formatMonitorCmd("netstat", "`netstat -nat | wc -l`")+
                formatMonitorCmd("memory_total", "`free -g | grep Mem | awk '{print $2}'`")+
                formatMonitorCmd("memory_use", "`free -g | grep Mem | awk '{print $3}'`")+
                formatMonitorCmd("memory_free", "`free -g | grep Mem | awk '{print $4}'`")+
                formatMonitorCmd("memory_available", "`free -g | grep Mem | awk '{print $7}'`")+
                formatMonitorCmd("ps_num", "`ps -ea | wc -l`")+
                formatMonitorCmd("thread_num", "`ps -eo nlwp | tail -n +2 | awk '{num_threads += $1} END {print num_threads}'`")+
                formatMonitorCmd("top", "`top -b | head -n 10 | tail -n 3 | awk 'BEGIN{count=0} {print $0 \"|\"}'`")+
                "echo -e $res";
        RemoteShellUtil rms = new RemoteShellUtil(ip, username, pass);
        String result = rms.exec( cmd );
        if(StringUtils.isBlank( result )){
            return null;
        }
        Map map = formatResult( result );
        return map;
    }
    
    private static Map formatResult(String result){
        Map<String,String> map = new HashMap();
        String[] lines = result.split("\n");
        for (String line : lines) {
            if( StringUtils.isBlank( line ) ){
                continue;
            }
            String[] tmp = line.split("'");
            if( "top".equals(tmp[0]) ){
                String arr[] = tmp[1].split("\\|");
                map.put("top_1", arr[0].trim());
                map.put("top_2", arr[1].trim());
                map.put("top_3", arr[2].trim());
            }else{
                map.put(tmp[0].trim(), tmp[1].trim());
            }
        }
        return map;
    }
