
SELECT
MIN(subscription_start), 
MAX(subscription_start)
FROM subscriptions;


SELECT
MIN(subscription_end), 
MAX(subscription_end)
FROM subscriptions;



SELECT DISTINCT segment
FROM subscriptions;






WITH months AS
(SELECT
  '2017-01-01' AS first_day,
  '2017-01-31' AS last_day
UNION
 SELECT
  '2017-02-01' AS first_day,
  '2017-02-28' AS last_day
UNION
 SELECT
  '2017-03-01' AS first_day,
  '2017-03-31' AS last_day
),
cross_join AS
(SELECT *
FROM subscriptions
cross JOIN months),
status AS
(SELECT id, first_day as month, segment,
CASE
  WHEN (subscription_start < first_day)
    AND (
      subscription_end > first_day OR subscription_end IS NULL
    		) THEN 1
  ELSE 0
END as is_active,
 CASE
	WHEN 
 		(subscription_end BETWEEN first_day and last_day)
 		THEN 1
 		ELSE 0
 END AS is_canceled
FROM cross_join),
status_aggregate AS
(SELECT 
 		month,
 		SUM (status.is_active) AS sum_active,
 		SUM (status.is_canceled) AS sum_canceled
FROM status
GROUP BY 1
)
SELECT 
	month, 
  	(1.0 * sum_canceled / sum_active) as 'churn_rate'
FROM status_aggregate;



WITH months AS
(SELECT
  '2017-01-01' AS first_day,
  '2017-01-31' AS last_day
UNION
 SELECT
  '2017-02-01' AS first_day,
  '2017-02-28' AS last_day
UNION
 SELECT
  '2017-03-01' AS first_day,
  '2017-03-31' AS last_day
),
cross_join AS
(SELECT *
FROM subscriptions
cross JOIN months),
status AS
(SELECT id, first_day as month, segment,
CASE
  WHEN (subscription_start < first_day)
    AND (
      subscription_end > first_day OR subscription_end IS NULL
    		) THEN 1
  ELSE 0
END as is_active,
 CASE
	WHEN 
 		(subscription_end BETWEEN first_day and last_day)
 		THEN 1
 		ELSE 0
 END AS is_canceled
FROM cross_join),
status_aggregate AS
(SELECT 
 		month,
 		segment,
 		SUM (status.is_active) AS sum_active,
 		SUM (status.is_canceled) AS sum_canceled
FROM status
GROUP BY 1,2
)
SELECT 
	month, segment,
  (1.0 * sum_canceled / sum_active) as 'churn_rate'	
FROM status_aggregate;