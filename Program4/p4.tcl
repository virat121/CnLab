set ns [new Simulator]

set tf [open p4.tr w]
$ns trace-all $tf

set nf [open p4.nam w]
$ns namtrace-all $nf

set s [$ns node]
set c [$ns node]

$ns color 1 Blue

$s label "Server"
$c label "Client"

$ns duplex-link $s $c 10Mb 10ms DropTail

$ns duplex-link-op $s $c orient right

set tcp0 [new Agent/TCP]
$ns attach-agent $s $tcp0

$tcp0 set packetSize_ 1500
set sink0 [new Agent/TCPSink]
$ns attach-agent $c $sink0

$ns connect $tcp0 $sink0

set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0

$tcp0 set fid_ 1

proc finish {} {
	global ns tf nf
	$ns flush-trace
	close $tf
	close $nf
	exec nam p4.nam &
	exec awk -f p4transfer.awk p4.tr &
	exec awk -f p4convert.awk p4.tr > convert.tr &
	exec xgraph convert.tr -geometry 800*400 -t "bytes_received_at_client" -x "time_in_secs" -y "bytes_in_bps" &
	exit 0
}

$ns at 0.1 "$ftp0 start"
$ns at 15.0 "$ftp0 stop"
$ns at 15.1 "finish"
$ns run
