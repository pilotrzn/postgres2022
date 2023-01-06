USE [MB4]
GO
/****** Object:  UserDefinedFunction [report].[fn_operations]    Script Date: 04.01.2023 21:46:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [report].[fn_operations] (@caseid INT)
RETURNS @table TABLE
    (
      id int,
      sourceid int,
      destid int,
      productid int,
      secondproductid int,
      measured float,
      reconciled float,
      caseid int
    )
AS 
BEGIN 

;WITH operations(
id,sourceid,destid,sourceprodid,destprodid,measured,reconciled,caseid)
as( 
   SELECT
      flows.id,
	  flows.sourceid,
	  flows.destid,
	  flows.productid,
	  flows.secondproductid,
	  metersvar.Measured,
	  flows.reconciled,
	  flows.caseid
   FROM ( 
         SELECT  
           flows.Id id, 
           flows.SourceId sourceid,
           flows.DestId destid, 
           FlowsVar.ProductId productid, 
           FlowsVar.SecondProductId secondproductid, 
           FlowsVar.Reconciled reconciled, 
           FlowsVar.CaseId caseid
         FROM dbo.Flows flows
         INNER JOIN dbo.FlowsVar FlowsVar
            ON flows.Id = FlowsVar.Id
         INNER join dbo.FlowsMeters  FlowsMeters
            ON FlowsMeters.FlowId = flows.id
         INNER join dbo.Objects obj
           ON FlowsMeters.Id = obj.Id
         where FlowsVar.CaseId = @caseid
           AND FlowsVar.CaseId >= ISNULL(obj.CreateCaseId, 2147483647)
           AND FlowsVar.CaseId < ISNULL(obj.DeleteCaseId, 2147483647)
		   ) Flows
		   inner join FlowsMeters flowsmeters
		           on flowsmeters.FlowId = flows.id
		   inner join MetersVar metersvar
		           on metersvar.Id = flowsmeters.MeterId 
		 		 and metersvar.CaseId = @caseid
union
select 
  Transactions.id, 
  Transactions.SourceId,
  Transactions.DestId,
  Transactions.ProductId,
  Transactions.SecondProductId,
  Transactions.Measured,
  Transactions.Reconciled,
  Transactions.CaseId
FROM dbo.Transactions AS Transactions
Where Transactions.CaseId = @caseid)

INSERT INTO @table
  select 
    allmovements.id,
	CASE 
      WHEN SourceObject.ObjectTypeId = 1024 AND SourcePort.UnitId IS NOT NULL -- Port
      THEN SourcePort.UnitId
      WHEN SourceObject.ObjectTypeId = 256 AND SourcePortNode.UnitId IS NOT NULL  -- Port Node
      THEN SourcePortNode.UnitId					
      ELSE SourceObject.Id
    END sourceid,
  case 
      when DestObject.ObjectTypeId = 1024 and DestPort.UnitId is not null 
      then DestPort.UnitId
      when DestObject.ObjectTypeId = 256 and DestPortNode.UnitId is not null 
      then DestPortNode.UnitId
      else DestObject.Id
    end As destid,
   allmovements.sourceprodid,
   allmovements.destprodid,
   allmovements.measured,
   allmovements.reconciled,
   allmovements.caseid

  from operations allmovements
  INNER JOIN dbo.Objects AS TransactionObject 
    ON TransactionObject.Id = allmovements.Id 
    AND TransactionObject.IsDeleted = 0	
  LEFT JOIN dbo.Objects AS SourceObject ON  SourceObject.Id = allmovements.SourceId
      AND ISNULL(SourceObject.CreateCaseId,2147483647) != ISNULL(SourceObject.DeleteCaseId,2147483647)
  	AND @caseid >= ISNULL(SourceObject.CreateCaseId,2147483647)
  	AND @caseid < ISNULL(SourceObject.DeleteCaseId,2147483647)
  LEFT JOIN dbo.Ports AS SourcePort ON  SourcePort.Id = allmovements.SourceId
  LEFT JOIN dbo.Ports AS SourcePortNode ON SourcePortNode.ConnectionObjId = allmovements.SourceId 
  LEFT JOIN Objects DestObject on DestObject.Id = allmovements.DestId
      AND ISNULL(DestObject.CreateCaseId,2147483647) != ISNULL(DestObject.DeleteCaseId,2147483647)
  	AND @caseid >= ISNULL(DestObject.CreateCaseId,2147483647)
  	AND @caseid < ISNULL(DestObject.DeleteCaseId,2147483647)
  LEFT JOIN Ports DestPort on DestPort.Id = allmovements.DestId
  LEFT JOIN Ports DestPortNode on DestPortNode.ConnectionObjId = allmovements.DestId
     and exists(SELECT id FROM Objects DestPortNodeObject WHERE DestPortNode.Id = DestPortNodeObject.Id and DestPortNodeObject.IsDeleted = 0)
  LEFT JOIN Flows DestFlows on DestFlows.Id = DestPortNode.FlowId
return 
end;