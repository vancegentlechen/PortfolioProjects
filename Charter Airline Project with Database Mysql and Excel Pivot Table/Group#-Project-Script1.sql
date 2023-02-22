SELECT CHAR_YEAR,CHAR_MON, sum(CHAR_HOURS_FLOWN) as Year_of_Hours_Flown
FROM charter c
join time_dim t
on c.CHAR_DATE=t.CHAR_DATE
group by CHAR_YEAR,CHAR_MON
