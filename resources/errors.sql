let
Source = #"Metrics Template",
  #"Detected Type Mismatches" = let
    tableWithOnlyPrimitiveTypes = Table.SelectColumns(Source, Table.ColumnsOfType(Source, {type nullable number, type nullable text, type nullable logical, type nullable date, type nullable datetime, type nullable datetimezone, type nullable time, type nullable duration})),
    recordTypeFields = Type.RecordFields(Type.TableRow(Value.Type(tableWithOnlyPrimitiveTypes))),
    fieldNames = Record.FieldNames(recordTypeFields),
    fieldTypes = List.Transform(Record.ToList(recordTypeFields), each [Type]),
    pairs = List.Transform(List.Positions(fieldNames), (i) => {fieldNames{i}, (v) => if v = null or Value.Is(v, fieldTypes{i}) then v else error [Message = "The type of the value does not match the type of the column.", Detail = v], fieldTypes{i}})
in
    Table.TransformColumns(Source, pairs),
  #"Added Index" = Table.AddIndexColumn(#"Detected Type Mismatches", "Row Number" ,1),
  #"Kept Errors" = Table.SelectRowsWithErrors(#"Added Index", {"Title", "Id", "Title.1", "Email IDId", "Email IDStringId", "Team Start Date", "Team Size", "Team Sprint duration", "Sprint Start Date", "Velocity planned", "Velocity actual", "# of Stories Planned", "# of Stories Done", "Capacity actual in_x", "Total number manual_", "Total number automat", "Total % Tests Automation", "Number of Refactors", "Unit test coverage_x", "Rating Bugs", "Rating Vulnerabilities", "Security hotspots", "Rating debt", "OData_% Duplications", "Overall quality", "Team Remarks", "Sprint Number", "Pegasus guardrail sc", "OData_% Stories Done", "Total number tests", "Team maturity", "Team attrition", "Scopevolatility", "Defectleakage", "Defectleakage-Total", "ContentTypeId", "ComplianceAssetId", "Rating bugs (n", "Rating Vulnerabilities_x00", "Rating Security hots", "Rating debt (n", "OData_% Duplications_x0020", "ID.1", "Modified", "Created", "AuthorId", "EditorId", "OData__UIVersionString", "Attachments", "Email ID", "Sprint ID", "Accuracy ", "Quardruple Rating", "SQ 09", "Metrics dashboard narratives (2).Narrative", "Metrics dashboard narratives (2).DateModified", "Metrics dashboard narratives (2).SprintID", "Metrics dashboard narratives (2).Dashboard", "Check Narrative", "Code Coverage Kpi", "Defect Leakage KPI", "Rating Debt KPi", "Rating Bug KPI", "Rating Vulnerability KPI", "SQ result KPI", "Quality Indicator", "Index", "Metrics Static Team Data.Sprint (duration_x00", "Metrics Static Team Data.Partner", "Metrics Static Team Data.DT mgr", "Metrics Static Team Data.Dep", "Metrics Static Team Data.Contact", "Metrics Static Team Data.Product Owner", "Metrics Static Team Data.ScrumMaster", "Producitvity", "Code Coverage % ", "Defect Leakage %", "Test Automation %", "% Stories Done", "GroupIndex"}),
  #"Reordered Columns" = Table.ReorderColumns(#"Kept Errors", {"Row Number", "Title", "Id", "Title.1", "Email IDId", "Email IDStringId", "Team Start Date", "Team Size", "Team Sprint duration", "Sprint Start Date", "Velocity planned", "Velocity actual", "# of Stories Planned", "# of Stories Done", "Capacity actual in_x", "Total number manual_", "Total number automat", "Total % Tests Automation", "Number of Refactors", "Unit test coverage_x", "Rating Bugs", "Rating Vulnerabilities", "Security hotspots", "Rating debt", "OData_% Duplications", "Overall quality", "Team Remarks", "Sprint Number", "Pegasus guardrail sc", "OData_% Stories Done", "Total number tests", "Team maturity", "Team attrition", "Scopevolatility", "Defectleakage", "Defectleakage-Total", "ContentTypeId", "ComplianceAssetId", "Rating bugs (n", "Rating Vulnerabilities_x00", "Rating Security hots", "Rating debt (n", "OData_% Duplications_x0020", "ID.1", "Modified", "Created", "AuthorId", "EditorId", "OData__UIVersionString", "Attachments", "Email ID", "Sprint ID", "Accuracy ", "Quardruple Rating", "SQ 09", "Metrics dashboard narratives (2).Narrative", "Metrics dashboard narratives (2).DateModified", "Metrics dashboard narratives (2).SprintID", "Metrics dashboard narratives (2).Dashboard", "Check Narrative", "Code Coverage Kpi", "Defect Leakage KPI", "Rating Debt KPi", "Rating Bug KPI", "Rating Vulnerability KPI", "SQ result KPI", "Quality Indicator", "Index", "Metrics Static Team Data.Sprint (duration_x00", "Metrics Static Team Data.Partner", "Metrics Static Team Data.DT mgr", "Metrics Static Team Data.Dep", "Metrics Static Team Data.Contact", "Metrics Static Team Data.Product Owner", "Metrics Static Team Data.ScrumMaster", "Producitvity", "Code Coverage % ", "Defect Leakage %", "Test Automation %", "% Stories Done", "GroupIndex"})
in
  #"Reordered Columns