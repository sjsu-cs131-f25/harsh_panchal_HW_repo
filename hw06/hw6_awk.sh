#!/bin/sh

# make out directory if it doesnt exist
mkdir -p out/

if [ -z "$1" ]; then
    echo "Error: No dataset file provided, please provide dataset file as an argument to this script. "
    exit 1
fi

DATASET_FILE=$1

# Task 1
echo "Task 1: Column selection & header handling; writing to out/task1.tsv"
awk -F $'\t' 'BEGIN {OFS="\t"} {print $3, $4, $7, $8, $9, $10}' $DATASET_FILE > out/task1.tsv

# Task 2
echo "Task 2: Basic filtering - verified-only, non-empty text; writing to out/task2.tsv"
awk -F $'\t' 'BEGIN {OFS="\t"} {rb=$14; gsub(/^ +| +$/,"", rb)} NR==1 || ($12=="Y" && length(rb)>=30) {print $3, $4, $7, $8, $9, $10}' $DATASET_FILE > out/task2.tsv

# Task 3
echo "Task 3: Helpfulness ratio bands; writing to out/task3.tsv"

awk -F $'\t' '
NR>1 {
	if ($10>0) {
		ratio=$9/$10;
		if (ratio>=0.8) s="HI"
		else if (ratio>=0.5) s="MID"
		else if (ratio>0) s="LO"
		else if (ratio==0) s="ZERO";
	}
	else s="NA"

	print s
}
' $DATASET_FILE | sort | uniq -c | sort -nr | awk 'BEGIN {OFS="\t"; print "band", "count"} {print $2, $1}' > out/task3.tsv

# Task 4
echo "Task 4: Per-product rating summary (min volume); writing to out/task4.tsv"

echo $'product_id\tcount\tavg_star_rating' > out/task4.tsv
awk -F $'\t' '
BEGIN {OFS="\t"}
NR>1 {sum[$4] += $8; cnt[$4]++}
END {
	for (p in sum)
		if (cnt[p] >= 50)
			printf "%s\t%s\t%.2f\n", p, cnt[p], sum[p]/cnt[p]
}
' $DATASET_FILE | sort -nr -k 3,3 -k 2,2 >> out/task4.tsv

# Task 5
echo "Task 5: Category × star distribution; writing to out/task5.tsv"

echo $'product_category\tstar_1\tstar_2\tstar_3\tstar_4\tstar_5\ttotal' > out/task5.tsv
awk -F $'\t' '
BEGIN {OFS="\t"}
NR>1 {cstar[$7, $8]++; cat[$7]++}
END {
	for (c in cat)
		printf "%s\t%d\t%d\t%d\t%d\t%d\t%d\n", c, cstar[c, 1], cstar[c, 2], cstar[c, 3], cstar[c, 4], cstar[c, 5], cat[c]
}
' $DATASET_FILE | sort -nr -k 7,7 >> out/task5.tsv

# Task 6
echo "Task 6: Monthly review volume & average rating; writing to out/task6.tsv"

echo $'month\tcount\tavg_star_rating' > out/task6.tsv
awk -F $'\t' '
BEGIN {OFS="\t"}
NR>1 {cnt[substr($15,1,7)]++; avgstar[substr($15,1,7)]++}
END {
	for (m in cnt)
		print m, cnt[m], avgstar[m]
}
' $DATASET_FILE | sort -n -k 2,2 >> out/task6.tsv

# Task 7
echo "Task 7: Keyword signal (case-insensitive via tolower); writing to out/task7.tsv"

echo $'keyword\tcount' > out/task7.tsv
awk -F $'\t' '
BEGIN {OFS="\t"}
NR>1 && $12=="Y" {
	if (match(tolower($14), "broken")) broken++
	else if (match(tolower($14), "defect")) defect++
	else if (match(tolower($14), "return")) ret++
	else if (match(tolower($14), "refund")) refund++;
}
END {
	print "broken", broken;
	print "defect", defect;
	print "return", ret;
	print "refund", refund;
}
' $DATASET_FILE | sort -nr -k 2,2 >> out/task7.tsv

# Task 8
echo "Task 8: Power users: reviewers with many reviews per day; writing to out/task8.tsv"

echo $'customer_id\tdate\tcount' > out/task8.tsv
awk -F $'\t' '
BEGIN {OFS="\t"}
NR>1 {cnt[$2,"\t",$15]++}
END {
	for (c in cnt)
		if (cnt[c] >= 5)
			print c, cnt[c]
}
' $DATASET_FILE | sort -nr -k 3,3 >> out/task8.tsv

# Task 9
echo "Task 9: Category verified-purchase share; writing to out/task9.tsv"

echo $'product_category\tcount_all\tpct_verified' > out/task9.tsv
awk -F $'\t' '
BEGIN {OFS="\t"}
NR>1 {total[$7]++; if ($12=="Y") verified[$7]++}
END {
	for (p in total)
		printf "%s\t%d\t%.1f\n", p, total[p], verified[p]/total[p]*100
}
' $DATASET_FILE | sort -nr -k 3,3 -k 2,2 >> out/task9.tsv

# Task 10
echo "Task 10: Top-N products by \"helpfulness lift\"; writing to out/task10.tsv" 

echo $'product_id\tcount_all\tavg_helpfulness_ratio' > out/task10.tsv
awk -F $'\t' '
BEGIN {OFS="\t"}
NR>1 && $10>0 {sumratio[$4]+=$9/$10; total[$4]++}
END {
	for (p in total)
		if (total[p]>=100)
			printf "%s\t%d\t%.2f\n", p, total[p], sumratio[p]/total[p]
}
' $DATASET_FILE | sort -nr -k 3,3 -k 2,2 >> out/task10.tsv
