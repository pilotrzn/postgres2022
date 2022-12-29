CREATE TABLE co.targetleveldailywithcumulative (
	targetleveldailyid int4 NOT NULL GENERATED ALWAYS AS IDENTITY,
	stationid int4 NULL,
	blockid int4 NULL,
	plandate timestamp NOT NULL,
	dailyplanvalue float8 NOT NULL,
	cumulativemonth float8 NOT NULL,
	ismonth int2 NULL,
	cumulativequarter float8 NOT NULL,
	isquarter int2 NULL,
	cumulativeyear float8 NOT NULL,
	isyear int2 NULL,
	numberofmonth int4 NULL,
	numberquarter int4 NULL,
	numberofyear int4 NULL,
	numberofweek int4 NULL,
	numberdayofyear int4 NULL,
	createdon timestamp NOT NULL DEFAULT now(),
	CONSTRAINT targetleveldailywithcumulative_pkey PRIMARY KEY (targetleveldailyid)
);


-- co.targetleveldailywithcumulative foreign keys

ALTER TABLE co.targetleveldailywithcumulative ADD CONSTRAINT targetleveldailywithcumulative_blockid_fkey FOREIGN KEY (blockid) REFERENCES co.energyblocklist(blockid);
ALTER TABLE co.targetleveldailywithcumulative ADD CONSTRAINT targetleveldailywithcumulative_stationid_fkey FOREIGN KEY (stationid) REFERENCES co.stationlist(stationid);