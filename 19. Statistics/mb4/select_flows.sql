SELECT 
	   fw.[Id]
      ,fw.[CaseId]
	  ,mv.Measured
      ,fw.[Reconciled]
      ,fw.[ProductId]
	  ,fw.[SecondProductId]
	  ,fl.SourceId
	  ,fl.DestId
      ,fw.[ObjectStatus]
      ,fw.[AI_IsImbalance]
      ,fw.[TechnoUpperBound]
      ,fw.[TechnoLowerBound]
      ,fw.[ReconciledAbsTolerance]
	  
  FROM [MB4].[dbo].[FlowsVar] fw
  inner join dbo.Flows fl on fl.Id = fw.Id
  inner join dbo.FlowsMeters fm on fm.FlowId = fl.Id
  inner join dbo.MetersVar mv on mv.Id = fm.MeterId
  inner join dbo.Objects obj on fm.Id = obj.Id and fw.CaseId>= isnull(obj.CreateCaseId,2147483647) and fw.CaseId < isnull(obj.DeleteCaseId,2147483647)
  where fw.CaseId=2440 and mv.CaseId=2440 