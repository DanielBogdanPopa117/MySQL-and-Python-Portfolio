import pandas as pd

df = pd.read_csv('movies.csv', sep='\t')
print(df)

high_rated = df[df['Rating'] > 9]
print(high_rated)

year_1994 = df[df['Year'] == 1994]
print(year_1994)

average_rating = df.groupby('Genre')['Rating'].mean
print(average_rating)

number_of_movies = df.groupby('Genre')['MovieID'].count
print(number_of_movies)

most_voted = df[df['Votes']==df['Votes'].max()]
print(most_voted)

top5_rated = df.sort_values(by='Rating', ascending = False).head(5)
print(top5_rated)

top5_votes = df.sort_values(by='Votes', ascending = False).head(5)
print(top5_votes)

genres = df['Genre'].unique()
print(genres)

year_most_movies = df.groupby('Year')['MovieID'].count().idxmax()
print(year_most_movies)

best_genre = df.groupby('Genre')['Rating'].mean().idxmax()
print(best_genre)