BEGIN {
    last=0;
    tcp_sz=0;
    ack_sz=0;
    total_sz=0;
}
{
    action=$1;
    time=$2;
    from=$3;
    to=$4;
    type=$5;
    pktsize=$6;
    if(type=="tcp" && action="r" && to=="3")
    	tcp_sz+=pktsize;
    if(type=="ack" && action="r" && to=="3")
    	ack_sz+=pktsize;
        
    total_sz+=pktsize;
}
END {
    printf("Time=%d\n", time);
    printf("Tcp size=%0.2f\n", tcp_sz);
    printf("Ack size=%f\n", ack_sz);
    printf("Total size=%f\n", total_sz);
}
