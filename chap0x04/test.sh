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
