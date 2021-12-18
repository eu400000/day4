let
    Source = SharePoint.Tables("https://connect2dll.sharepoint.com/sites/sdm/SDM/", [ApiVersion = 15]),
    #"4514626d-326c-43f9-ba14-e9460649e333" = Source{[Id="4514626d-326c-43f9-ba14-e9460649e333"]}[Items],
    #"Renamed Columns" = Table.RenameColumns(#"4514626d-326c-43f9-ba14-e9460649e333",{{"ID", "ID.1"}}),
    #"Removed Columns" = Table.RemoveColumns(#"Renamed Columns",{"GUID", "FileSystemObjectType", "ServerRedirectedEmbedUri", "ServerRedirectedEmbedUrl", "FirstUniqueAncestorSecurableObject", "RoleAssignments", "AttachmentFiles", "ContentType", "GetDlpPolicyTip", "FieldValuesAsHtml", "FieldValuesAsText", "FieldValuesForEdit", "File", "Folder", "LikedByInformation", "ParentList", "Properties", "Versions", "Author", "Editor"}),
    #"Duplicated Column" = Table.DuplicateColumn(#"Removed Columns", "Title", "Title - Copy"),
    #"Duplicated Column1" = Table.DuplicateColumn(#"Duplicated Column", "Sprint Start Date", "Sprint Start Date - Copy"),
    #"Extracted Date" = Table.TransformColumns(#"Duplicated Column1",{{"Sprint Start Date - Copy", DateTime.Date, type date}}),
    #"Changed Type" = Table.TransformColumnTypes(#"Extracted Date",{{"Sprint Start Date - Copy", Int64.Type}}),
    #"Merged Columns" = Table.CombineColumns(Table.TransformColumnTypes(#"Changed Type", {{"Sprint Start Date - Copy", type text}}, "nl-NL"),{"Title - Copy", "Sprint Start Date - Copy"},Combiner.CombineTextByDelimiter("", QuoteStyle.None),"Sprint ID"),
    #"Sorted Rows" = Table.Sort(#"Merged Columns",{{"Sprint ID", Order.Ascending}}),
    #"Extracted Date1" = Table.TransformColumns(#"Sorted Rows",{{"Sprint Start Date", DateTime.Date, type date}}),
    #"Changed Type1" = Table.TransformColumnTypes(#"Extracted Date1",{{"Team Size", type number}, {"OData_% Duplications", type number}}),
    #"Added Custom" = Table.AddColumn(#"Changed Type1", "Accuracy ", each ([Velocity actual]/[Velocity planned])),
    #"Changed Type2" = Table.TransformColumnTypes(#"Added Custom",{{"Accuracy ", Percentage.Type}}),
    #"Renamed Columns1" = Table.RenameColumns(#"Changed Type2",{{"Total % tests_", "Total % Tests Automation"}}),
    #"Replaced Value10" = Table.ReplaceValue(#"Renamed Columns1",".",",",Replacer.ReplaceText,{"Total % Tests Automation"}),
    #"Changed Type3" = Table.TransformColumnTypes(#"Replaced Value10",{{"Total % Tests Automation", type number}}),
    #"Added Conditional Column" = Table.AddColumn(#"Changed Type3", "Rating Bug Ch", each if [Rating Bugs] = 5 then "A" else if [Rating Bugs] = 4 then "B" else if [Rating Bugs] = 3 then "C" else if [Rating Bugs] = 2 then "D" else if [Rating Bugs] = 1 then "E" else "-"),
    #"Added Conditional Column1" = Table.AddColumn(#"Added Conditional Column", "Rating Debt Ch", each if [Rating debt] = 5 then "A" else if [Rating debt] = 4 then "B" else if [Rating debt] = 3 then "C" else if [Rating debt] = 2 then "D" else if [Rating debt] = 1 then "E" else "-"),
    #"Added Conditional Column2" = Table.AddColumn(#"Added Conditional Column1", "Rating Vulnerabilities Ch", each if [Rating Vulnerabilities] = 5 then "A" else if [Rating Vulnerabilities] = 4 then "B" else if [Rating Vulnerabilities] = 3 then "C" else if [Rating Vulnerabilities] = 2 then "D" else if [Rating Vulnerabilities] = 1 then "E" else "-"),
    #"Added Conditional Column3" = Table.AddColumn(#"Added Conditional Column2", "SQ 09", each if [Rating Bugs] = null then null else if [Rating debt] = null then null else if [Rating Bugs] > [Rating debt] then [Rating debt] else [Rating Bugs]),
    #"Added Conditional Column4" = Table.AddColumn(#"Added Conditional Column3", "SQ Result ch", each if [SQ 09] = 5 then "A" else if [SQ 09] = 4 then "B" else if [SQ 09] = 3 then "C" else if [SQ 09] = 2 then "D" else if [SQ 09] = 1 then "E" else "-"),
    #"Changed Type4" = Table.TransformColumnTypes(#"Added Conditional Column4",{{"SQ Result ch", type text}}),
    #"Merged Columns1" = Table.CombineColumns(#"Changed Type4",{"SQ Result ch", "Rating Vulnerabilities Ch", "Rating Debt Ch", "Rating Bug Ch"},Combiner.CombineTextByDelimiter("", QuoteStyle.None),"Merged"),
    #"Renamed Columns2" = Table.RenameColumns(#"Merged Columns1",{{"Merged", "Quardruple Rating"}}),
    #"Merged Queries" = Table.NestedJoin(#"Renamed Columns2", {"Sprint ID"}, #"Metrics dashboard narratives (2)", {"SprintID"}, "Metrics dashboard narratives (2)", JoinKind.LeftOuter),
    #"Expanded Metrics dashboard narratives (2)" = Table.ExpandTableColumn(#"Merged Queries", "Metrics dashboard narratives (2)", {"Narrative", "DateModified", "SprintID", "Dashboard"}, {"Metrics dashboard narratives (2).Narrative", "Metrics dashboard narratives (2).DateModified", "Metrics dashboard narratives (2).SprintID", "Metrics dashboard narratives (2).Dashboard"}),
    #"Changed Type5" = Table.TransformColumnTypes(#"Expanded Metrics dashboard narratives (2)",{{"Metrics dashboard narratives (2).Narrative", type text}, {"Metrics dashboard narratives (2).DateModified", type date}, {"Metrics dashboard narratives (2).SprintID", type text}, {"Metrics dashboard narratives (2).Dashboard", Int64.Type}}),
    #"Added Custom1" = Table.AddColumn(#"Changed Type5", "Check Narrative", each if [#"Metrics dashboard narratives (2).Narrative"] = null then [Team Remarks] else [#"Metrics dashboard narratives (2).Narrative"]),
    #"Added Conditional Column6" = Table.AddColumn(#"Added Custom1", "Code Coverage Kpi", each if [Unit test coverage_x] >= 80 then 1 else 0),
    #"Replaced Value" = Table.ReplaceValue(#"Added Conditional Column6",null,0,Replacer.ReplaceValue,{"Defectleakage-Total"}),
    #"Added Custom2" = Table.AddColumn(#"Replaced Value", "Defect Leakage KPI", each if [#"Defectleakage-Total"] >=1 and [#"Defectleakage-Total"] < 15 then 1

else 0),
    #"Added Custom3" = Table.AddColumn(#"Added Custom2", "Rating Debt KPi", each if [Rating debt] = null then 0
else if [Rating debt] >= 4 then 1
else 0),
    #"Added Custom4" = Table.AddColumn(#"Added Custom3", "Rating Bug KPI", each if [Rating Bugs] =null then 0
else if [Rating Bugs] >=4 then 1
else 0),
    #"Added Custom5" = Table.AddColumn(#"Added Custom4", "Rating Vulnerability KPI", each if [Rating Vulnerabilities] =null then 0
else if [Rating Vulnerabilities] >=4 then 1
else 0),
    #"Added Custom6" = Table.AddColumn(#"Added Custom5", "SQ result KPI", each if [SQ 09] = null then 0 else if [SQ 09] >= 4 then 1 else 0),
    #"Added Custom7" = Table.AddColumn(#"Added Custom6", "Quality Indicator", each if [Defect Leakage KPI] =1 
and [Code Coverage Kpi] =1 then 1

else if [Defect Leakage KPI]= 1 and [Rating Debt KPi]=1 
and [Rating Bug KPI]=1 and [Rating Vulnerability KPI]=1
and [SQ result KPI]=1 then 1

else if [Code Coverage Kpi]= 1 and [Rating Debt KPi]=1 
and [Rating Bug KPI]=1 and [Rating Vulnerability KPI]=1
and [SQ result KPI]=1 then 1

else 0),
    #"Added Index" = Table.AddIndexColumn(#"Added Custom7", "Index", 1, 1, Int64.Type),
    #"Merged Queries1" = Table.NestedJoin(#"Added Index", {"Title"}, #"Metrics Static Team Data", {"Title"}, "Metrics Static Team Data", JoinKind.LeftOuter),
    #"Expanded Metrics Static Team Data" = Table.ExpandTableColumn(#"Merged Queries1", "Metrics Static Team Data", {"Sprint (duration_x00", "Partner", "DT mgr", "Dep", "Contact", "Product Owner", "ScrumMaster"}, {"Metrics Static Team Data.Sprint (duration_x00", "Metrics Static Team Data.Partner", "Metrics Static Team Data.DT mgr", "Metrics Static Team Data.Dep", "Metrics Static Team Data.Contact", "Metrics Static Team Data.Product Owner", "Metrics Static Team Data.ScrumMaster"}),
    #"Changed Type6" = Table.TransformColumnTypes(#"Expanded Metrics Static Team Data",{{"Metrics Static Team Data.Sprint (duration_x00", type number}}),
    #"Replaced Value9" = Table.ReplaceValue(#"Changed Type6",null,0,Replacer.ReplaceValue,{"Team Size"}),
    #"Added Custom8" = Table.AddColumn(#"Replaced Value9", "Producitvity", each if [Velocity actual]=0 or [Team Size]=0 then 0
else 
 [Velocity actual]/[Team Size]),
    #"Replaced Value8" = Table.ReplaceValue(#"Added Custom8",null,0,Replacer.ReplaceValue,{"Producitvity"}),
    #"Replaced Value1" = Table.ReplaceValue(#"Replaced Value8",null,0,Replacer.ReplaceValue,{"Producitvity"}),
    #"Changed Type7" = Table.TransformColumnTypes(#"Replaced Value1",{{"Producitvity", type number}}),
    #"Replaced Value2" = Table.ReplaceValue(#"Changed Type7",#nan,0,Replacer.ReplaceValue,{"Producitvity"}),
    #"Replaced Value3" = Table.ReplaceValue(#"Replaced Value2",#nan,0,Replacer.ReplaceValue,{"Producitvity"}),
    #"Replaced Value4" = Table.ReplaceValue(#"Replaced Value3",#nan,0,Replacer.ReplaceValue,{"Producitvity"}),
    #"Added Custom9" = Table.AddColumn(#"Replaced Value4", "Code Coverage % ", each [Unit test coverage_x]/100),
    #"Changed Type8" = Table.TransformColumnTypes(#"Added Custom9",{{"Code Coverage % ", Percentage.Type}}),
    #"Added Custom10" = Table.AddColumn(#"Changed Type8", "Defect Leakage %", each [#"Defectleakage-Total"]/100),
    #"Changed Type9" = Table.TransformColumnTypes(#"Added Custom10",{{"Defect Leakage %", Percentage.Type}}),
    #"Added Custom11" = Table.AddColumn(#"Changed Type9", "Test Automation %", each [#"Total % Tests Automation"]/100),
    #"Changed Type10" = Table.TransformColumnTypes(#"Added Custom11",{{"Test Automation %", Percentage.Type}}),
    #"Renamed Columns3" = Table.RenameColumns(#"Changed Type10",{{"Number of Stories_x0", "# of Stories Planned"}, {"Number of Stories_x00", "# of Stories Done"}}),
    #"Added Custom12" = Table.AddColumn(#"Renamed Columns3", "% Stories Done", each [#"# of Stories Done"]/[#"# of Stories Planned"]),
    #"Changed Type11" = Table.TransformColumnTypes(#"Added Custom12",{{"% Stories Done", Percentage.Type}, {"Defectleakage", type number}}),
    #"Replaced Value5" = Table.ReplaceValue(#"Changed Type11",null,0,Replacer.ReplaceValue,{"Defectleakage"}),
    #"Changed Type12" = Table.TransformColumnTypes(#"Replaced Value5",{{"Defectleakage-Total", type number}}),
    #"Added Custom13" = Table.AddColumn(#"Changed Type12", "New 9 Defect Leakage", each if  [Defectleakage]=0 or [#"Defectleakage-Total"]=0
then 0
else ([Defectleakage]/[#"Defectleakage-Total"])),
    #"Changed Type13" = Table.TransformColumnTypes(#"Added Custom13",{{"New 9 Defect Leakage", Percentage.Type}}),
    #"Renamed Columns4" = Table.RenameColumns(#"Changed Type13",{{"New 9 Defect Leakage", "New Defect Leakage %"}}),
    #"Sorted Rows1" = Table.Sort(#"Renamed Columns4",{{"Title", Order.Ascending}, {"Sprint Start Date", Order.Descending}}),
    #"Grouped Rows" = Table.Group(#"Sorted Rows1", {"Title"}, {{"AllRows", each _, type table [Id=number, Title=text, Email IDId=number, Email IDStringId=text, Team Start Date=any, Team Size=nullable number, Team Sprint duration=any, Sprint Start Date=date, Velocity planned=number, Velocity actual=number, #"# of Stories Planned"=number, #"# of Stories Done"=number, Capacity actual in_x=nullable number, Total number manual_=text, Total number automat=number, #"Total % Tests Automation"=nullable number, Number of Refactors=number, Unit test coverage_x=number, Rating Bugs=nullable number, Rating Vulnerabilities=nullable number, Security hotspots=nullable number, Rating debt=nullable number, #"OData_% Duplications"=nullable number, Overall quality=any, Team Remarks=nullable text, Sprint Number=text, Pegasus guardrail sc=nullable text, #"OData_% Stories Done"=any, Total number tests=any, Team maturity=any, Team attrition=any, Scopevolatility=nullable number, Defectleakage=nullable number, #"Defectleakage-Total"=nullable number, ContentTypeId=text, ComplianceAssetId=any, #"Rating bugs (n"=nullable number, Rating Vulnerabilities_x00=nullable number, Rating Security hots=nullable number, #"Rating debt (n"=nullable number, #"OData_% Duplications_x0020"=nullable number, ID.1=number, Modified=datetime, Created=datetime, AuthorId=number, EditorId=number, OData__UIVersionString=text, Attachments=logical, Email ID=nullable record, Sprint ID=text, #"Accuracy "=nullable number, Quardruple Rating=text, SQ 09=nullable number, #"Metrics dashboard narratives (2).Narrative"=nullable text, #"Metrics dashboard narratives (2).DateModified"=nullable date, #"Metrics dashboard narratives (2).SprintID"=nullable text, #"Metrics dashboard narratives (2).Dashboard"=nullable number, Check Narrative=nullable text, Code Coverage Kpi=number, Defect Leakage KPI=number, Rating Debt KPi=number, Rating Bug KPI=number, Rating Vulnerability KPI=number, SQ result KPI=number, Quality Indicator=number, Index=number, #"Metrics Static Team Data.Sprint (duration_x00"=nullable number, Metrics Static Team Data.Partner=text, Metrics Static Team Data.DT mgr=text, Metrics Static Team Data.Dep=text, Metrics Static Team Data.Contact=nullable text, Metrics Static Team Data.Product Owner=nullable text, Producitvity=nullable number, #"Code Coverage % "=nullable number, #"Defect Leakage %"=nullable number, #"Test Automation %"=nullable number, #"% Stories Done"=nullable number, #"New Defect Leakage %"=nullable number]}}),
    Indexed = Table.TransformColumns(#"Grouped Rows", {{"AllRows", each Table.AddIndexColumn(_, "GroupIndex", 0,1)}}),
#"Expanded AllRows" = Table.ExpandTableColumn(Indexed, "AllRows", {"Id", "Title", "Email IDId", "Email IDStringId", "Team Start Date", "Team Size", "Team Sprint duration", "Sprint Start Date", "Velocity planned", "Velocity actual", "# of Stories Planned", "# of Stories Done", "Capacity actual in_x", "Total number manual_", "Total number automat", "Total % Tests Automation", "Number of Refactors", "Unit test coverage_x", "Rating Bugs", "Rating Vulnerabilities", "Security hotspots", "Rating debt", "OData_% Duplications", "Overall quality", "Team Remarks", "Sprint Number", "Pegasus guardrail sc", "OData_% Stories Done", "Total number tests", "Team maturity", "Team attrition", "Scopevolatility", "Defectleakage", "Defectleakage-Total", "ContentTypeId", "ComplianceAssetId", "Rating bugs (n", "Rating Vulnerabilities_x00", "Rating Security hots", "Rating debt (n", "OData_% Duplications_x0020", "ID.1", "Modified", "Created", "AuthorId", "EditorId", "OData__UIVersionString", "Attachments", "Email ID", "Sprint ID", "Accuracy ", "Quardruple Rating", "SQ 09", "Metrics dashboard narratives (2).Narrative", "Metrics dashboard narratives (2).DateModified", "Metrics dashboard narratives (2).SprintID", "Metrics dashboard narratives (2).Dashboard", "Check Narrative", "Code Coverage Kpi", "Defect Leakage KPI", "Rating Debt KPi", "Rating Bug KPI", "Rating Vulnerability KPI", "SQ result KPI", "Quality Indicator", "Index", "Metrics Static Team Data.Sprint (duration_x00", "Metrics Static Team Data.Partner", "Metrics Static Team Data.DT mgr", "Metrics Static Team Data.Dep", "Metrics Static Team Data.Contact", "Metrics Static Team Data.Product Owner", "Metrics Static Team Data.ScrumMaster", "Producitvity", "Code Coverage % ", "Defect Leakage %", "Test Automation %", "% Stories Done", "GroupIndex"}, {"Id", "Title.1", "Email IDId", "Email IDStringId", "Team Start Date", "Team Size", "Team Sprint duration", "Sprint Start Date", "Velocity planned", "Velocity actual", "# of Stories Planned", "# of Stories Done", "Capacity actual in_x", "Total number manual_", "Total number automat", "Total % Tests Automation", "Number of Refactors", "Unit test coverage_x", "Rating Bugs", "Rating Vulnerabilities", "Security hotspots", "Rating debt", "OData_% Duplications", "Overall quality", "Team Remarks", "Sprint Number", "Pegasus guardrail sc", "OData_% Stories Done", "Total number tests", "Team maturity", "Team attrition", "Scopevolatility", "Defectleakage", "Defectleakage-Total", "ContentTypeId", "ComplianceAssetId", "Rating bugs (n", "Rating Vulnerabilities_x00", "Rating Security hots", "Rating debt (n", "OData_% Duplications_x0020", "ID.1", "Modified", "Created", "AuthorId", "EditorId", "OData__UIVersionString", "Attachments", "Email ID", "Sprint ID", "Accuracy ", "Quardruple Rating", "SQ 09", "Metrics dashboard narratives (2).Narrative", "Metrics dashboard narratives (2).DateModified", "Metrics dashboard narratives (2).SprintID", "Metrics dashboard narratives (2).Dashboard", "Check Narrative", "Code Coverage Kpi", "Defect Leakage KPI", "Rating Debt KPi", "Rating Bug KPI", "Rating Vulnerability KPI", "SQ result KPI", "Quality Indicator", "Index", "Metrics Static Team Data.Sprint (duration_x00", "Metrics Static Team Data.Partner", "Metrics Static Team Data.DT mgr", "Metrics Static Team Data.Dep", "Metrics Static Team Data.Contact", "Metrics Static Team Data.Product Owner", "Metrics Static Team Data.ScrumMaster", "Producitvity", "Code Coverage % ", "Defect Leakage %", "Test Automation %", "% Stories Done", "GroupIndex"}),
#"Changed Type14" = Table.TransformColumnTypes(#"Expanded AllRows",{{"GroupIndex", Int64.Type}, {"% Stories Done", Percentage.Type}}),
    #"Replaced Value6" = Table.ReplaceValue(#"Changed Type14",#nan,0,Replacer.ReplaceValue,{"% Stories Done"}),
    #"Changed Type15" = Table.TransformColumnTypes(#"Replaced Value6",{{"Accuracy ", Percentage.Type}}),
    #"Replaced Value7" = Table.ReplaceValue(#"Changed Type15",#nan,0,Replacer.ReplaceValue,{"Accuracy "}),
    #"Changed Type16" = Table.TransformColumnTypes(#"Replaced Value7",{{"Accuracy ", Percentage.Type}, {"Test Automation %", Percentage.Type}, {"Producitvity", type number}, {"Code Coverage % ", Percentage.Type}, {"Defectleakage", type number}, {"Defectleakage-Total", type number}})
in
    #"Changed Type16"

