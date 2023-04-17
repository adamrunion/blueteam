remote_address=$1
remote_port=$2
connection=$(netstat -tn | awk -v remote_address="$remote_address" -v remote_port="$remote_port" '$5 == remote_address":"remote_port {print $0}')

echo $remote_address
echo $remote_port