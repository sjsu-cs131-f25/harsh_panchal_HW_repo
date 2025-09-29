#!/bin/sh

# A)
# Pick product_id with multiple reviews containing html tags, punctuation and write to product_id.txt
echo 'Finding product_id with most the reviews containing html tags and punctuation...'
cut amazon_reviews.tsv -f 4,14 | grep -E '<[^>]+>' | grep -E '[[:punct:]]' | cut -f 1 | sort | uniq -c | sort -nr | head -n 1 | sed -E 's/^[[:space:]]+[0-9]+ //' > product_id.txt
# Explanation: cut to only product_id and review_body columns to remove
# unnecessary text, first filter out lines that do not contain html tags using
# grep, again grep to filter out lines that do not contain puncutation, cut to
# only product_id, get the most frequent product_id with sort and uniq -c, last
# sed is to remove the leading number that contains the count. 

# Extract only rows with matching product_id, keep only the review_body
echo 'Collecting review_body columns of the product_id found above into review_body_raw.txt...'
cut amazon_reviews.tsv -f 4,14 | grep -f product_id.txt | cut -f 2 > review_body_raw.txt
# Explanation: cut to only product_id and review_body columns, filter to only
# lines that contain the product_id we found earlier with grep, only keep the
# review_body column with cut. 

# B)
# Strip HTML tags, remove punctuation, remove whole-word stopwords, normalize whitespace
echo 'Cleaning review_body_raw.txt and saving to review_body_clean.txt...'
sed -E 's/<[^>]+>/ /g' review_body_raw.txt | sed -E 's/[].,;?!()\[]+/ /g' | sed -E 's/\<(and|or|if|in|it|the|a|an)\>//Ig' | sed -E 's/^[[:space:]]+//; s/[[:space:]]+$//; s/[[:space:]]+/ /g' > review_body_clean.txt
# Explanation: Each sed command in the pipeline does one of the four required
# steps. The first command removes all html tags. The second command removes
# all periods, commas, semicolons, question marks, exclamation marks, square
# brackets, and parentheses. The third command removes whole-word stopwords.
# The final command trims all whitespace at the beginning and end of the line,
# and replaces all whitespace in the middle with just a singular space. 

# C)
# Tokenize review_body_clean.txt, count and sort, reformat the output and save to tokens_top.tsv
echo 'Tokenizing and counting tokens within review_body_clean.txt and saving to tokens_top.tsv...'
sed -E 's/[[:space:]]/\n/g' review_body_clean.txt | sort | uniq -c | sort -nr | sed -E 's/[[:space:]]+([0-9]+) (.+)/\2\t\1/g' > tokens_top.tsv

echo 'All done.' 
