
-- Cast unix timestamp 
Select
    dateadd(S, 708998400, '1970-01-01')
    --dateadd(S, [unixtime], '1970-01-01')


-- Only date
SELECT CONVERT(date, getdate())