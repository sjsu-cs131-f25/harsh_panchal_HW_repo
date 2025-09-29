# Homework 5

The goal of this homework was to use sed to be able to edit and replace text
with the command line. First, I found a `product_id` from the amazon reviews
dataset with the most reviews containing extraneous html tags and punctuation
by using grep. I extracted the review bodies of the `product_id` to
`review_body_raw.txt`.

Utilizing sed, I stripped the raw review body of extraneous html tags and
punctuation, saving this to `review_body_clean.txt`. Cleaning the review bodies
of html tags and punctuation removed unnecessary junk that would make the data
containing the counts of the tokens less readable and easy to understand.

I then tokenized the results by splitting on space and created a table of every
token and its frequency to `top_tokens.tsv`. This allows us to easily perform
analysis on the review bodies by looking at the count of each token. 

Lastly, I created a wordcloud of the top 100 tokens to easily visualize the
data. From the data, it is clear to see that the `product_id` must be a device
that allows for video streaming of some kind, as common words include: YouTube,
Netflix, Amazon, TV, video, streaming, chromecast, etc. One thing I noticed
about the tokens is that they are case-sensitive due to the way we tokenized.
Therefore, tokens like tv are separate from TV. This could be fixed by
lowercasing all of the text in the review bodies before tokenizing, but that
approach has it's own pros and cons of losing information. 
