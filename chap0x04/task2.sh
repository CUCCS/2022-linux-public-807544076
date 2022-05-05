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