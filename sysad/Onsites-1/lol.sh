touch network_bills.txt
touch highbill.txt
declare -A array1
totcost=0
while IFS=' ' read -r time timee user ip dd ud status; do
    if [[ $status == "Unbilled" ]]; then
        n=$(bc <<< "($dd+$ud) * 0.05")
        totcost=$(bc <<< "$totcost + $n")
        if [[ -n ${array1[$user]} ]]; then
            array1["$user"]=$(bc <<< "${array1[$user]} + $n")
        else
            array1["$user"]=$n
        fi
    fi
    for user in "${!array1[@]}"; do
        echo "$user ${array1[$user]}"
    done | sort -k2nr > network_bills.txt
done < ./network_usage.log
echo "Sorted file:"
cat network_bills.txt
echo "TOP 3 users:"
head -n 3 network_bills.txt | tee highbill.txt
echo "TOTAL COST OVERALL:"
echo "$totcost"