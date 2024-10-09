# Netflix Movies and TV Shows Data Analysis using SQL
![Netflix](https://github.com/agujalwar/Netflix_SQL_Project/blob/main/logo.png)

## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Objectives

- Understand Content Catalog: Analyze the distribution of Movies vs. TV Shows, genres, and countries to evaluate the diversity of Netflix’s offerings.
- Identify Content Trends: Examine release patterns over time to discover key trends in Netflix’s content production and acquisition.
- Target Audience Analysis: Assess content ratings to determine the primary audience Netflix serves and identify potential gaps in age group or content type.
- Analyze Global Reach: Investigate which countries produce the most content for Netflix and explore regional opportunities for growth.
- Popular Genres and Directors: Identify the most successful genres, directors, and content categories to inform future production and licensing decisions.

## Dataset

The data for this project is sourced from the Kaggle dataset:

- **Dataset Link:** [Movies Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

- ## Schema

```sql
CREATE TABLE netflix_shows (
    show_id VARCHAR(10) PRIMARY KEY,
    show_type VARCHAR(20),
    title VARCHAR(255),
    director VARCHAR(255),
    show_cast TEXT,
    country VARCHAR(255),
    date_added DATE,
    release_year INT,
    rating VARCHAR(10),
    duration VARCHAR(50),
    listed_in TEXT,
    description TEXT
);
```

