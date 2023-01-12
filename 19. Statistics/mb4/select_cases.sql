SELECT
  m.modelname
, a.analyse_name
, a.type
, c.case_id
, c.starttime
, c.endtime
FROM
  cases c
JOIN
  mb.analyses a
    ON a.id = c.analyses_id
JOIN
  mb.models m
    ON m.id = a.model_id
WHERE
  a.type = 4 AND
  m.modelname = 'Завод'
ORDER BY
  c.starttime;