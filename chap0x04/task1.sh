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
                convert -undercolor Black -fill blue -pointsize 100 -draw "text 100,100 '${sub[1]}'" "$file" "watermarked_$file"
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
                convert -undercolor Black -fill blue -pointsize 100 -draw "text 100,100 '${sub[1]}'" "$file" "watermarked_$n_file"
            done
            for file in $(ls | find -name "*.png")
            do
                n_file="${file:2}"
                convert -undercolor Black -fill blue -pointsize 100 -draw "text 100,100 '${sub[1]}'" "$file" "watermarked_$n_file"
            done
            for file in $(ls | find -name "*.svg")
            do
                n_file="${file:2}"
                convert -undercolor Black -fill blue -pointsize 100 -draw "text 100,100 '${sub[1]}'" "$file" "watermarked_$n_file"
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
