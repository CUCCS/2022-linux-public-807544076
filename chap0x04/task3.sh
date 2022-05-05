#! /bin/bash

# 统计访问来源主机 TOP 100 和分别对应出现的总次数
count_host(){
echo "-------------正在统计最多出现的主机名和总次数-------------"

cut -f1 web_log.tsv | awk '/[a-z]/' | sort | uniq -c | sort -r -n | head -n 100
}

# 统计访问来源主机 TOP 100 IP 和分别对应出现的总次数
count_IP(){
echo "-------------正在统计最多出现的 IP 和总次数-------------"

cut -f1 web_log.tsv | grep -E "^([0-9]{1,3}\.){3}[0-9]{1,3}$" | sort | uniq -c | sort -r -n | head -n 100

}
# 统计最频繁被访问的 URL TOP 100
count_URL(){
echo "-------------正在统计最频繁被访问的 URL TOP 100-------------"

cut -f5 web_log.tsv | sort | uniq -c | sort -r -n | head -n 100
}

# 统计不同响应状态码的出现次数和对应百分比
count_Respone(){
echo "-------------正在统计不同响应状态码的出现次数和对应百分比-------------"

# 获得响应码类型和次数
a=$(cut -f6 web_log.tsv | grep "[0-9]" | sort | uniq -c)
flag=''
type=()
times=()
counter=0
for line in $a
do  
    if [[ "$flag" ]]
    then
        type+=("$line")
        flag=''
    else
        times+=("$line")
        flag='a'
    fi
done

for i in "${times[@]}"
do
    counter=$(expr $counter + "$i")
done

for (( j=0;j<"${#type[@]}";j++ ))
do
    p=$(echo "scale=6; ${times[j]} / $counter * 100" | bc)
    echo "状态码 ${type[j]} 共出现 ${times[j]} 次,占 $p %"
done
}

# 统计不同4XX状态码对应的TOP 10 URL和对应出现的总次数
count_SRespone(){
echo "-------------正在统计不同4XX状态码对应的TOP 10 URL和对应出现的总次数-------------"

echo "403:"
awk '$6==403{print $1}' web_log.tsv | sort | uniq -c | sort -r -n | head -n 10

echo "404:"
awk '$6==404{print $1}' web_log.tsv | sort | uniq -c | sort -r -n | head -n 10
}

# 给定URL输出TOP 100访问来源主机
count_Special(){
    echo "-------------正在统计该 URL 的 TOP 100 访问来源主机-------------"
    url=$1
    r=$(eval "awk '\$5==\"$url\"{print \$1}' web_log.tsv | sort | uniq -c | sort -r -n | head -n 100")
    echo "$r"
}

while getopts :hiursS: opt
do
    case $opt in
    h)
        count_host
    ;;
    i)
        count_IP
    ;;
    u)
        count_URL
    ;;
    r)
        count_Respone
    ;;
    s)
        count_SRespone
    ;;
    S)
        count_Special "$OPTARG"
    ;;
    *)
    echo """
    --------------------------------------------------
    web_log process
    author: Oceanfish
    version: 1.0
    --------------------------------------------------
    Usage:
        ./task3.sh [options] [argument]

        options:
            -h 统计访问来源主机 TOP 100 和分别对应出现的总次数
            -i 统计访问来源主机 TOP 100 IP 和分别对应出现的总次数
            -u 统计最频繁被访问的 URL TOP 100
            -r 统计不同响应状态码的出现次数和对应百分比
            -s 统计不同4XX状态码对应的TOP 10 URL和对应出现的总次数
            -S <url> 给定URL输出TOP 100访问来源主机
    """
    ;;
    esac
done