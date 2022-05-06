# H4
> author: OceanFish

## 题目：
<strong>任务一：</strong>用bash编写一个图片批处理脚本，实现以下功能：
* 支持命令行参数方式使用不同功能
* 支持对指定目录下所有支持格式的图片文件进行批处理
* 支持以下常见图片批处理功能的单独使用或组合使用
    * 支持对jpeg格式图片进行图片质量压缩
    * 支持对jpeg/png/svg格式图片在保持原始宽高比的前提下压缩分辨率
    * 支持对图片批量添加自定义文本水印
    * 支持批量重命名（统一添加文件名前缀或后缀，不影响原始文件扩展名）
    * 支持将png/svg图片统一转换为jpg格式图片

<strong>任务二：</strong>用bash编写一个文本批处理脚本，对以下附件分别进行批量处理完成相应的数据统计任务：
* 统计不同年龄区间范围（20岁以下、[20-30]、30岁以上）的球员数量、百分比
* 统计不同场上位置的球员数量、百分比
* 名字最长的球员是谁？名字最短的球员是谁？
* 年龄最大的球员是谁？年龄最小的球员是谁？

<strong>任务三：</strong>用bash编写一个文本批处理脚本，对以下附件分别进行批量处理完成相应的数据统计任务：
* 统计访问来源主机TOP 100和分别对应出现的总次数
* 统计访问来源主机TOP 100 IP和分别对应出现的总次数
* 统计最频繁被访问的URL TOP 100
* 统计不同响应状态码的出现次数和对应百分比
* 分别统计不同4XX状态码对应的TOP 10 URL和对应出现的总次数
* 给定URL输出TOP 100访问来源主机

## 解答：
---
### 任务一：

准备工作：

安装 jpg 压缩工具 `jpegoptim`
```bash
$ sudo apt install jpegoptim
```

安装图片处理工具 `imagemagick`
```bash
$ sudo apt install imagemagick
```

代码:

```sh
#! /bin/bash
# image process
# author: OceanFish

while getopts :j:J:c:C:w:W:r:R:t:h opt
do
    case $opt in
        j)
            # 获得所有参数，放在 sub 数组中
            sub=("$OPTARG")
            until [[ $(eval "echo \${$OPTIND}") =~ ^-.* ]] || [ -z "$(eval "echo \${$OPTIND}")" ]; do
                sub+=("$(eval "echo \${$OPTIND}")")
                OPTIND=$((OPTIND + 1))
            done
            for arg in "${sub[@]}"
            do
                jpegoptim "$arg"
            done
            ;;
        J)
            cd "$OPTARG" || exit
            for file in $(ls | find -name "*.jpg")
            do
                jpegoptim "$file"
            done
        ;;
        c)
            sub=("$OPTARG")
            until [[ $(eval "echo \${$OPTIND}") =~ ^-.* ]] || [ -z "$(eval "echo \${$OPTIND}")" ]; do
                sub+=("$(eval "echo \${$OPTIND}")")
                OPTIND=$((OPTIND + 1))
            done
            files=()
            for arg in "${sub[@]}"
            do
                if [[ $arg =~ % ]]
                then
                    p=$arg
                else
                    files+=("$arg")
                fi
            done
            for file in "${files[@]}"
            do
                convert "$file" -resize "$p" "new_${file}"
            done
        ;;
        C)
            sub=("$OPTARG")
            until [[ $(eval "echo \${$OPTIND}") =~ ^-.* ]] || [ -z "$(eval "echo \${$OPTIND}")" ]; do
                sub+=("$(eval "echo \${$OPTIND}")")
                OPTIND=$((OPTIND + 1))
            done
            cd "${sub[0]}" || exit
            for file in $(ls | find -name "*.jpg")
            do
                n_file="${file:2}"
                convert "$file" -resize "${sub[1]}" "new_$n_file"
            done
            for file in $(ls | find -name "*.png")
            do
                n_file="${file:2}"
                convert "$file" -resize "${sub[1]}" "new_$n_file"
            done
            for file in $(ls | find -name "*.svg")
            do
                n_file="${file:2}"
                convert "$file" -resize "${sub[1]}" "new_$n_file"
            done
        ;;
        w)
            sub=("$OPTARG")
            until [[ $(eval "echo \${$OPTIND}") =~ ^-.* ]] || [ -z "$(eval "echo \${$OPTIND}")" ]; do
                sub+=("$(eval "echo \${$OPTIND}")")
                OPTIND=$((OPTIND + 1))
            done
            files=()
            for arg in "${sub[@]}"
            do
                if [[ $arg =~ .jpg ]] || [[ $arg =~ .png ]] || [[ $arg =~ .svg ]]
                then
                    files+=("$arg")
                else
                    TEXT="$arg"
                fi
            done
            for file in "${files[@]}"
            do
                convert -undercolor Black -fill blue -pointsize 100 -draw "text 100,100 '${sub[1]}'" "$file" "watermarkd_$file"
            done
        ;;

        W)
            sub=("$OPTARG")
            until [[ $(eval "echo \${$OPTIND}") =~ ^-.* ]] || [ -z "$(eval "echo \${$OPTIND}")" ]; do
                sub+=("$(eval "echo \${$OPTIND}")")
                OPTIND=$((OPTIND + 1))
            done
            cd "${sub[0]}" || exit
            for file in $(ls | find -name "*.jpg")
            do
                n_file="${file:2}" 
                convert -undercolor Black -fill blue -pointsize 100 -draw "text 100,100 '${sub[1]}'" "$file" "watermarkd_$n_file"
            done
            for file in $(ls | find -name "*.png")
            do
                n_file="${file:2}"
                convert -undercolor Black -fill blue -pointsize 100 -draw "text 100,100 '${sub[1]}'" "$file" "watermarkd_$n_file"
            done
            for file in $(ls | find -name "*.svg")
            do
                n_file="${file:2}"
                convert -undercolor Black -fill blue -pointsize 100 -draw "text 100,100 '${sub[1]}'" "$file" "watermarkd_$n_file"
            done
        ;;
        r)
            sub=("$OPTARG")
            until [[ $(eval "echo \${$OPTIND}") =~ ^-.* ]] || [ -z "$(eval "echo \${$OPTIND}")" ]; do
                sub+=("$(eval "echo \${$OPTIND}")")
                OPTIND=$((OPTIND + 1))
            done
            files=()
            non_files=()
            for arg in "${sub[@]}"
            do
                if [[ $arg =~ .jpg ]] || [[ $arg =~ .png ]] || [[ $arg =~ .svg ]]
                then
                    files+=("$arg")
                else
                    non_files+=("$arg")
                fi
            done
            for i in "${non_files[@]}"
            do
                if [[ "$i" == "pre" || "$i" == "suf" ]]
                then
                    choice="$i"
                else
                    TEXT="$i"
                fi
            done
            if test -z "$TEXT"
            then
                echo "命名参数缺失" || exit
            fi
            if test -z "$choice"
            then
                for file in "${files[@]}"
                do      
                    suf=".${file#*.}"
                    mv "$file" "${TEXT}${suf}"
                done
            else
                for file in "${files[@]}"
                do      
                    suf=".${file#*.}"
                    if [[ $choice == "pre" ]]
                    then
                        mv "${file}" "${TEXT}${file}"
                    elif  [[ "${sub[2]}" == "suf" ]]
                    then
                        mv "${file}" "${file%.*}${TEXT}${suf}"
                    else
                        echo "参数错误"
                    fi
                done
            fi
        ;;
        R)
            sub=("$OPTARG")
            until [[ $(eval "echo \${$OPTIND}") =~ ^-.* ]] || [ -z "$(eval "echo \${$OPTIND}")" ]; do
                sub+=("$(eval "echo \${$OPTIND}")")
                OPTIND=$((OPTIND + 1))
            done
            if test -z "${sub[2]}"
            then
                echo "参数缺失"
            fi
            cd "${sub[0]}" || exit
            for file in *
            do
                if [[ "${sub[2]}" == "pre" ]]
                then
                    mv "${file}" "${sub[1]}${file}"
                elif [[ "${sub[2]}" == "suf" ]]
                then
                    suf=".${file#*.}"
                    mv "${file}" "${file%.*}${sub[1]}${suf}"
                else
                    echo "参数错误"
                fi
            done
            
        ;;
        t)
            sub=("$OPTARG")
            until [[ $(eval "echo \${$OPTIND}") =~ ^-.* ]] || [ -z "$(eval "echo \${$OPTIND}")" ]; do
                sub+=("$(eval "echo \${$OPTIND}")")
                OPTIND=$((OPTIND + 1))
            done
            cd "${sub[0]}" || exit
            for file in *
            do
                fn="${file%.*}"
                convert "$file" "${fn}.jpg"
            done 
        ;;
        h | *)
            echo """
            -----------------------------------------------------------------------
            Picture Process Scripe
            Version: 1.0 
            Author: Oceanfish
            -----------------------------------------------------------------------
            Usage: 
                ./task1.sh [operations] [argument(s)]
                
                operations:
                    -j <file_name> [<file_name>] 压缩 jpg 文件
                    -J <path> 批量压缩文件夹里所有 jpg 文件
                    -c <file_name> [<file_name>] <percentage> 成比例压缩分辨率
                    -C <path> <percentage> 批量成比例压缩文件夹里所有图片的分辨率
                    -w <file_name> [<file_name>] <content> 添加自定义内容水印
                    -W <path> <content> 为文件夹中所有图片添加自定义内容水印
                    -r <file_name> [<file_name>] <text> [<pre|suf>] 添加文件名前后缀或直接改名
                    -R <path> <text> <pre|suf> 批量修改文件夹里图片名称（按顺序排序）
                    -t <path> 批量将文件夹中所有 png/svg 转换成 jpg
            """
            ;;
    esac
done
```
---

### 任务二:

先对待统计的文件 `worldcupplayerinfo.tsv` 进行分析
可知其有
```
Group   Country Rank	Jersey	Position	Age	Selections	Club	Player	Captain
```
这些列
可以使用 `cut` 命令将其按列分开再进行数据统计分析

在程序运行中发现在 `Position` 中有一个特殊表达 `Défenseur`
经查明为法语中的 `Defender`，遂计数在 `Defender` 中

代码:
```sh
#! /bin/bash

# 变量存储区

# Columns
a=$(cut -f6 worldcupplayerinfo.tsv) # Age
p=$(cut -f5 worldcupplayerinfo.tsv) # Position
n=$(cut -f9 worldcupplayerinfo.tsv > player.txt) # Player 
# 由于该列的特殊性（有空格），需要将其先输出至 txt 文件再做处理


# Functions
counter=0
#--------------------------------------------------------
# (1)、(4)

y20=0 # Younger than 20
b23=0 # Between 20 and 30
e30=0 # Elder than 30
max=0 # Max age
min=30 # Min age

for v in $a
do
    if [[ "$v" == "Age" ]]
    then
        continue
    else
        counter=$(expr $counter + 1)
        if [[ "$v" -ge "$max" ]]
        then
            max="$v"
        fi
        if [[ "$v" -le "$min" ]]
        then
            min="$v"
        fi
        if [[ "$v" -gt 30 ]]
        then
            e30=$(expr $e30 + 1)
        elif [[ "$v" -lt 20 ]]
        then
            y20=$(expr $y20 + 1)
        else
            b23=$(expr $b23 + 1)
        fi
    fi
done

# show
echo "总人数为 $counter 人"
r=$(echo "scale=4; $y20 / $counter * 100" | bc)
echo "20 岁以下有 $y20 人,占 $r %"
r=$(echo "scale=4; $b23 / $counter * 100" | bc)
echo "20 岁到 30 岁之间有 $b23 人,占 $r %"
r=$(echo "scale=4; $e30 / $counter * 100" | bc)
echo "30 岁以上有 $e30 人,占 $r %"
echo "年龄最大为 $max 岁,最小为 $min 岁"
echo ""

#--------------------------------------------------------
# (2)

gn=0 # Goalie
dn=0 # Defender
mn=0 # Midfielder
fn=0 # Forward


for v in $p
do
    if [[ "$v" == "Position" ]]
    then
        continue
    fi
    if [[ "$v" == "Goalie" ]]
    then
        gn=$(expr $gn + 1)
    elif [[ "$v" == "Defender" ]]
    then
        dn=$(expr $dn + 1)
    elif [[ "$v" == "Midfielder" ]]
    then
        mn=$(expr $mn + 1)
    elif [[ "$v" == "Forward" ]]
    then
        fn=$(expr $fn + 1)
    else
        echo "Special: $v"
        echo "Defender + 1"
        # 由于法语的存在，dn 加 1
        dn=$(expr $dn + 1)
    fi
done

echo ""
r=$(echo "scale=4; $gn / $counter * 100" | bc)
echo "Goalie 共$gn人,占$r%"
r=$(echo "scale=4; $dn / $counter * 100" | bc)
echo "Defender 共$dn人,占$r%"
r=$(echo "scale=4; $mn / $counter * 100" | bc)
echo "Midfielder 共$mn人,占$r%"
r=$(echo "scale=4; $fn / $counter * 100" | bc)
echo "Forward 共$fn人,占$r%"

#--------------------------------------------------------
# (3)

maxname=0 # 最长名字长度
minname=10 # 最短名字长度

while read line
do
    if [[ "${#line}" -ge "$maxname" ]]
    then
        maxname=${#line}
        maxn=$line
    elif [[ "${#line}" -le "$minname" ]]
    then
        minname=${#line}
        minn=$line
    fi
done < player.txt

echo ""
echo "名字最长的球员是: $maxn ,长度为 $maxname"
echo "名字最短的球员是: $minn ,长度为 $minname"
```

---

### 任务三:

基本处理原理同 `task2`

代码:
```shell
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
```
---

## 执行测试模块:

编写 `test.sh` 脚本用于测试三个任务的完成情况
代码:
```shell
#! /bin/bash
echo "当前工作目录："
pwd
cd ./chap0x04 || exit
printf "\n开始测试:\n"
# Task 1
echo "Task 1"
bash ./task1.sh -h

echo "对 jpg 文件进行质量压缩"
bash ./task1.sh -j img1.jpg img2.jpg
bash ./task1.sh -J ./abc

echo "对 jpeg/png/svg 格式图片在保持原始宽高比的前提下压缩分辨率"
bash ./task1.sh -c img1.jpg img3.png 10%
bash ./task1.sh -C ./abc

echo "对图片批量添加自定义文本水印"
bash ./task1.sh -w img2.jpg img3.png "Oceanfish"
bash ./task1.sh -W ./abc "Oceanfish"

echo "批量重命名（统一添加文件名前缀或后缀，不影响原始文件扩展名）"
bash ./task1.sh -r img1.jpg "oceanfish_" "pre"
bash ./task1.sh -r img2.jpg "_oceanfish" "suf"
bash ./task1.sh -R ./abc "oceanfish_" "pre"

echo "将 png/svg 图片统一转换为 jpg 格式图片"
bash ./task1.sh -t ./abc

# Task 2
echo "Task 2"
bash ./task2.sh

# Task 3
echo "Task 3"
bash ./task3.sh -?
bash ./task3.sh -h
bash ./task3.sh -i
bash ./task3.sh -u
bash ./task3.sh -r
bash ./task3.sh -s
bash ./task3.sh -S "/images/ksclogo-medium.gif"
```

编写 `.travis.yml` 构建运行
```yml
language: bash

before_install: 
  - sudo apt-get update && sudo apt install p7zip-full
  - wget "https://c4pr1c3.gitee.io/linuxsysadmin/exp/chap0x04/worldcupplayerinfo.tsv"
  - wget "https://c4pr1c3.github.io/LinuxSysAdmin/exp/chap0x04/web_log.tsv.7z"
  - 7z e web_log.tsv.7z
  - mv worldcupplayerinfo.tsv ./chap0x04
  - mv web_log.tsv ./chap0x04

script:
  - bash ./chap0x04/test.sh
```

---

## 问题及解决方法:

问题：对 `Shell` 和 `Linux` 的命令操作不熟悉
解决：通过 Google 搜索文档和示例代码学习，不断实验

---

## 参考资料:

[图片处理工具](https://blog.csdn.net/HUXINY/article/details/87879249)

[jpg 批量压缩工具](https://blog.csdn.net/lsqtzj/article/details/109263810)

[gepopts 一个选项如何接受多个参数](https://stackoverflow.com/questions/7529856/retrieving-multiple-arguments-for-a-single-option-using-getopts-in-bash)

[shell 字符串处理](http://c.biancheng.net/view/1120.html)

[如何从 tsv 文件中提取一列](https://www.thinbug.com/q/49340780)

[将管道输出赋值给 Shell 中的变量](https://blog.csdn.net/qq_33401821/article/details/112280124)

[Linux 命令大全](https://www.runoob.com/linux/linux-command-manual.html)

