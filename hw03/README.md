# HW 3 Explanation

### Command Explanations

The first two commands I ran were the following:

`head -n 1 input > output`
`tail -n +2 input | shuf -n 10000 >> output`

This adds the header line to the output. Then it grabs all lines besides the
header, picks 10,000 random lines with shuf, and appends it to the same file. 

Then, I ran the following line to create the star rating histogram:

`tail -n +2 input | cut -f 8 | sort | uniq -c | sort -k 1 -gr > output`

Tail gets every line besides the header, cut grabs the column, then I sort and
count unique values. Lastly, I sort by the first column which contains the
count.

The following lines used the same process but with minor modifications.

`tail -n +2 input | cut -f 2 | sort | uniq -c | sort -k 1 -gr | head -n 10 > output`
`tail -n +2 input | cut -f 4,6 | sort | uniq -c | sort -k 1 -gr | head -n 10 > output`
`tail -n +2 input | cut -f 7 | sort | uniq -c | sort -k 1 -gr > output`

I simply changed the columns to whichever column was necessary. I also used
head at the end to only get the top 10 lines where necessary.

Finally, I ran:

`history > hw03_history.txt`

to save the history.

### Observations

One observation I made about the review star ratings is most of the reviews
were 5 stars. This is surprising because I was under the assumption that most
people review to complain about the product being faulty, and don't generally
leave a review if the product is good.

One observation I made about the categories of the products is that the most
frequent category with reviews was mobile applications. This kind of makes
sense because people are more likely to leave reviews about smartphone apps,
but it's also surprising because most people don't really think of Amazon to be
a marketplace for smartphone applications. Usually apps are downloaded from the
App Store or Google Play Store. 
