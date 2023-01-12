explain analyze
SELECT
  CASE
    WHEN source_object.object_type_id = 1024 AND
      source_port.unit_id IS NOT NULL THEN
      source_port.unit_id
    WHEN source_object.object_type_id = 256 AND
      source_port_node.unit_id IS NOT NULL THEN
      source_port_node.unit_id
    ELSE
      source_object.object_id
  END source_id
, CASE
    WHEN dest_object.object_type_id = 1024 AND
      dest_port.unit_id IS NOT NULL THEN
      dest_port.unit_id
    WHEN dest_object.object_type_id = 256 AND
      dest_port_node.unit_id IS NOT NULL THEN
      dest_port_node.unit_id
    ELSE
      dest_object.object_id
  END dest_id
, t.product_id
, t.second_product_id
, t.measured
, t.reconciled
, t.case_id
FROM
  mb.transactions t
JOIN
  mb.objects transaction_object
    ON transaction_object.id = t.transaction_id AND
    transaction_object.is_deleted = 0
LEFT JOIN
  mb.objects source_object
    ON source_object.object_id = t.source_id AND
    coalesce(source_object.create_case_id, 2147483647) <> coalesce(source_object.delete_case_id, 2147483647)
LEFT JOIN
  mb.objects dest_object
    ON dest_object.object_id = t.dest_id AND
    coalesce(dest_object.create_case_id, 2147483647) <> coalesce(dest_object.delete_case_id, 2147483647)
LEFT JOIN
  mb.ports source_port
    ON source_port.port_id = t.source_id
LEFT JOIN
  mb.ports source_port_node
    ON source_port_node.connection_obj_id = t.source_id
LEFT JOIN
  mb.ports dest_port
    ON dest_port.port_id = t.dest_id
LEFT JOIN
  mb.ports dest_port_node
    ON dest_port_node.connection_obj_id = t.dest_id
where t.case_id = 1951;
