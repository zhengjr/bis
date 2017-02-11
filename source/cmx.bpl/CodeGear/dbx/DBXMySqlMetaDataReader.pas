{ *********************************************************************** }
{                                                                         }
{ Delphi DBX Framework                                                    }
{                                                                         }
{ Copyright (c) 1997-2007 Borland Software Corporation                    }
{                                                                         }
{ *********************************************************************** }

unit DBXMySqlMetaDataReader;
interface
uses
  DBXMetaDataNames,
  DBXMetaDataReader,
  DBXPlatformUtil,
  DBXSqlScanner,
  DBXTableStorage;
type
  
  /// <summary>  MySqlCustomMetaDataReader contains custom code for MySQL.
  /// </summary>
  /// <remarks>  For MySQL version 4 and earlier the output of SHOW commands are filtered
  ///   into metadata schema table structures.
  ///   For MySQL version 5 and up the system views are filtered for MySQL specifics.
  /// </remarks>
  TDBXMySqlCustomMetaDataReader = class(TDBXBaseMetaDataReader)
  public
    type

      /// <summary> MySqlColumnType holds a data type definition.
      /// </summary>
            
      /// <summary> MySqlColumnType holds a data type definition.
      /// </summary>
      TDBXMySqlColumnType = class
      public
        FDataType: WideString;
        FPrecision: Integer;
        FScale: Integer;
        FUnsigned: Boolean;
        FUnicode: Boolean;
        FNotnull: Boolean;
      end;

      TDBXMySqlParameter = class(TDBXMySqlCustomMetaDataReader.TDBXMySqlColumnType)
      public
        FName: WideString;
        FMode: WideString;
        FOrdinal: Integer;
      end;

      TDBXMySqlForeignKey = class
      public
        constructor Create;
        destructor Destroy; override;
        procedure Reset; virtual;
      public
        FConstraintName: WideString;
        FKeyColumns: TDBXStringList;
        FReferencedTableName: WideString;
        FReferencedColumns: TDBXStringList;
      end;


      /// <summary>  MySql4TablesCursor is a filter for a cursor providing tables.
      /// </summary>
      /// <remarks>  This filter takes the output from "SHOW TABLES" and transforms it into a Tables schema table.
      /// </remarks>
            
      /// <summary>  MySql4TablesCursor is a filter for a cursor providing tables.
      /// </summary>
      /// <remarks>  This filter takes the output from "SHOW TABLES" and transforms it into a Tables schema table.
      /// </remarks>
      TDBXMySql4TablesCursor = class(TDBXBaseMetaDataReader.TDBXSanitizedTableCursor)
      public
        function IsNull(Ordinal: Integer): Boolean; override;
        function GetString(Ordinal: Integer): WideString; override;
      protected
        constructor Create(const Reader: TDBXMySqlCustomMetaDataReader; const Columns: TDBXColumnDescriptorArray; const Cursor: TDBXTableStorage);
        function FindStringSize(const Ordinal: Integer; const SourceColumns: TDBXColumnDescriptorArray): Integer; override;
      private
        const ShowTablesTableNameOrdinal = 0;
      end;


      /// <summary>  MySqlColumnsTableCursor provides the IsUnicode based on the character
      ///   set of the column.
      /// </summary>
            
      /// <summary>  MySqlColumnsTableCursor provides the IsUnicode based on the character
      ///   set of the column.
      /// </summary>
      TDBXMySqlColumnsTableCursor = class(TDBXBaseMetaDataReader.TDBXColumnsTableCursor)
      public
        constructor Create(Reader: TDBXMySqlCustomMetaDataReader; Version5: Boolean; Original: TDBXTableStorage; Sanitized: TDBXTableStorage);
        function GetInt32(Ordinal: Integer): Integer; override;
        function GetBoolean(Ordinal: Integer): Boolean; override;
      private
        FOriginal: TDBXTableStorage;
        FVersion5: Boolean;
      private
        const MysqlIsUnicode = TDBXColumnsIndex.DbxDataType;
        const MysqlIsUnsigned = TDBXColumnsIndex.DbxDataType + 1;
      end;


      /// <summary>  MySql4ColumnsCursor is a filter for a cursor providing table columns.
      /// </summary>
      /// <remarks>  This filter takes the output from "SHOW COLUMNS FROM <tablename>" and transforms it into a Columns schema table.
      /// </remarks>
            
      /// <summary>  MySql4ColumnsCursor is a filter for a cursor providing table columns.
      /// </summary>
      /// <remarks>  This filter takes the output from "SHOW COLUMNS FROM <tablename>" and transforms it into a Columns schema table.
      /// </remarks>
      TDBXMySql4ColumnsCursor = class(TDBXBaseMetaDataReader.TDBXSanitizedTableCursor)
      public
        destructor Destroy; override;
        function Next: Boolean; override;
        procedure Close; override;
        function IsNull(Ordinal: Integer): Boolean; override;
        function GetString(Ordinal: Integer): WideString; override;
        function GetInt32(Ordinal: Integer): Integer; override;
        function GetBoolean(Ordinal: Integer): Boolean; override;
      protected
        constructor Create(const Reader: TDBXMySqlCustomMetaDataReader; const Columns: TDBXColumnDescriptorArray; const Sql: WideString; const TableName: WideString);
        function FindStringSize(const Ordinal: Integer; const SourceColumns: TDBXColumnDescriptorArray): Integer; override;
      private
        function InitNextCursor: Boolean;
        function ComputeDefaultValue: WideString;
        function ComputeAutoIncrement: Boolean;
        function ComputeNullable: Boolean;
      private
        FReader: TDBXMySqlCustomMetaDataReader;
        FTables: TDBXStringList;
        FTableIndex: Integer;
        FSql: WideString;
        FTableName: WideString;
        FColumnNumber: Integer;
        FColumnType: TDBXMySqlCustomMetaDataReader.TDBXMySqlColumnType;
      private
        const ShowColumnsFieldOrdinal = 0;
        const ShowColumnsTypeOrdinal = 1;
        const ShowColumnsNullOrdinal = 2;
        const ShowColumnsKeyOrdinal = 3;
        const ShowColumnsDefaultOrdinal = 4;
        const ShowColumnsExtraOrdinal = 5;
      end;


      /// <summary>  MySql4IndexesCursor is a filter for a cursor providing indexes.
      /// </summary>
      /// <remarks>  This filter takes the output from "SHOW INDEX FROM <tablename>" and transforms it into a Indexes schema table.
      /// </remarks>
            
      /// <summary>  MySql4IndexesCursor is a filter for a cursor providing indexes.
      /// </summary>
      /// <remarks>  This filter takes the output from "SHOW INDEX FROM <tablename>" and transforms it into a Indexes schema table.
      /// </remarks>
      TDBXMySql4IndexesCursor = class(TDBXBaseMetaDataReader.TDBXSanitizedTableCursor)
      public
        destructor Destroy; override;
        function Next: Boolean; override;
        procedure Close; override;
        function IsNull(Ordinal: Integer): Boolean; override;
        function GetString(Ordinal: Integer): WideString; override;
        function GetBoolean(Ordinal: Integer): Boolean; override;
      protected
        constructor Create(const Reader: TDBXMySqlCustomMetaDataReader; const Columns: TDBXColumnDescriptorArray; const Sql: WideString; const TableName: WideString);
        function FindStringSize(const Ordinal: Integer; const SourceColumns: TDBXColumnDescriptorArray): Integer; override;
      private
        function InitNextCursor: Boolean;
        function ComputeConstraintName: WideString;
      private
        FReader: TDBXMySqlCustomMetaDataReader;
        FTables: TDBXStringList;
        FTableIndex: Integer;
        FSql: WideString;
        FTableName: WideString;
        FUniqueIndex: Boolean;
        FIndexName: WideString;
        FPrevIndexName: WideString;
        FPrevTableName: WideString;
      private
        const ShowIndexTableOrdinal = 0;
        const ShowIndexNonUniqueOrdinal = 1;
        const ShowIndexKeyNameOrdinal = 2;
        const ShowIndexSeqInIndexOrdinal = 3;
        const ShowIndexColumnNameOrdinal = 4;
        const ShowIndexCollationOrdinal = 5;
        const ShowIndexCardinalityOrdinal = 6;
        const ShowIndexSubPartOrdinal = 7;
        const ShowIndexPackedOrdinal = 8;
        const ShowIndexNullOrdinal = 9;
        const ShowIndexIndexTypeOrdinal = 10;
        const ShowIndexCommentOrdinal = 11;
      end;


      /// <summary>  MySql4IndexColumnsCursor is a filter for a cursor providing index columns.
      /// </summary>
      /// <remarks>  This filter takes the output from "SHOW INDEX FROM <tablename>" and transforms it into a IndexColumns schema table.
      /// </remarks>
            
      /// <summary>  MySql4IndexColumnsCursor is a filter for a cursor providing index columns.
      /// </summary>
      /// <remarks>  This filter takes the output from "SHOW INDEX FROM <tablename>" and transforms it into a IndexColumns schema table.
      /// </remarks>
      TDBXMySql4IndexColumnsCursor = class(TDBXBaseMetaDataReader.TDBXSanitizedTableCursor)
      public
        destructor Destroy; override;
        function Next: Boolean; override;
        procedure Close; override;
        function IsNull(Ordinal: Integer): Boolean; override;
        function GetString(Ordinal: Integer): WideString; override;
        function GetInt32(Ordinal: Integer): Integer; override;
        function GetBoolean(Ordinal: Integer): Boolean; override;
      protected
        constructor Create(const Reader: TDBXMySqlCustomMetaDataReader; const Columns: TDBXColumnDescriptorArray; const Sql: WideString; const TableName: WideString; const IndexName: WideString);
        function FindStringSize(const Ordinal: Integer; const SourceColumns: TDBXColumnDescriptorArray): Integer; override;
      private
        function InitNextCursor: Boolean;
      private
        FReader: TDBXMySqlCustomMetaDataReader;
        FTables: TDBXStringList;
        FTableIndex: Integer;
        FSql: WideString;
        FWantedIndexName: WideString;
        FTableName: WideString;
        FIndexName: WideString;
      private
        const ShowIndexTableOrdinal = 0;
        const ShowIndexNonUniqueOrdinal = 1;
        const ShowIndexKeyNameOrdinal = 2;
        const ShowIndexSeqInIndexOrdinal = 3;
        const ShowIndexColumnNameOrdinal = 4;
        const ShowIndexCollationOrdinal = 5;
        const ShowIndexCardinalityOrdinal = 6;
        const ShowIndexSubPartOrdinal = 7;
        const ShowIndexPackedOrdinal = 8;
        const ShowIndexNullOrdinal = 9;
        const ShowIndexIndexTypeOrdinal = 10;
        const ShowIndexCommentOrdinal = 11;
      end;


      /// <summary>  MySql4ForeignKeyCursor is a filter for a cursor providing foreign keys.
      /// </summary>
      /// <remarks>  This filter takes the output from "SHOW CREATE TABLE <tablename>" and transforms it into a ForeignKey schema table.
      /// </remarks>
            
      /// <summary>  MySql4ForeignKeyCursor is a filter for a cursor providing foreign keys.
      /// </summary>
      /// <remarks>  This filter takes the output from "SHOW CREATE TABLE <tablename>" and transforms it into a ForeignKey schema table.
      /// </remarks>
      TDBXMySql4ForeignKeyCursor = class(TDBXBaseMetaDataReader.TDBXSanitizedTableCursor)
      public
        destructor Destroy; override;
        function Next: Boolean; override;
        procedure Close; override;
        function IsNull(Ordinal: Integer): Boolean; override;
        function GetString(Ordinal: Integer): WideString; override;
      protected
        constructor Create(const Reader: TDBXMySqlCustomMetaDataReader; const Columns: TDBXColumnDescriptorArray; const Sql: WideString; const TableName: WideString);
        function FindStringSize(const Ordinal: Integer; const SourceColumns: TDBXColumnDescriptorArray): Integer; override;
      private
        function InitNextCursor: Boolean;
      public
        FKey: TDBXMySqlCustomMetaDataReader.TDBXMySqlForeignKey;
      private
        FReader: TDBXMySqlCustomMetaDataReader;
        FTables: TDBXStringList;
        FTableIndex: Integer;
        FSql: WideString;
        FTableName: WideString;
        FSqlCreateTable: WideString;
        FParseIndex: Integer;
      private
        const ShowCreateTableSqlOrdinal = 1;
      end;


      /// <summary>  MySql4ForeignKeyColumnsCursor is a filter for a cursor providing foreign key columns.
      /// </summary>
      /// <remarks>  This filter takes the output from "SHOW CREATE TABLE <tablename>" and transforms it into a ForeignKeyColumns schema table.
      /// </remarks>
            
      /// <summary>  MySql4ForeignKeyColumnsCursor is a filter for a cursor providing foreign key columns.
      /// </summary>
      /// <remarks>  This filter takes the output from "SHOW CREATE TABLE <tablename>" and transforms it into a ForeignKeyColumns schema table.
      /// </remarks>
      TDBXMySql4ForeignKeyColumnsCursor = class(TDBXBaseMetaDataReader.TDBXSanitizedTableCursor)
      public
        destructor Destroy; override;
        function Next: Boolean; override;
        procedure Close; override;
        function IsNull(Ordinal: Integer): Boolean; override;
        function GetString(Ordinal: Integer): WideString; override;
        function GetInt32(Ordinal: Integer): Integer; override;
      protected
        constructor Create(const Reader: TDBXMySqlCustomMetaDataReader; const Columns: TDBXColumnDescriptorArray; const Sql: WideString; const TableName: WideString; const ForeignKeyName: WideString; const PrimaryTableName: WideString; const PrimaryKeyName: WideString);
        function FindStringSize(const Ordinal: Integer; const SourceColumns: TDBXColumnDescriptorArray): Integer; override;
      private
        function InitNextCursor: Boolean;
      public
        FKey: TDBXMySqlCustomMetaDataReader.TDBXMySqlForeignKey;
      private
        FReader: TDBXMySqlCustomMetaDataReader;
        FTables: TDBXStringList;
        FTableIndex: Integer;
        FSql: WideString;
        FTableName: WideString;
        FForeignKeyName: WideString;
        FPrimaryTableName: WideString;
        FPrimaryKeyName: WideString;
        FSqlCreateTable: WideString;
        FParseIndex: Integer;
        FKeyIndex: Integer;
      private
        const ShowCreateTableSqlOrdinal = 1;
      end;


      /// <summary>  MySqlProcedureSourcesCursor is a filter for a cursor providing procedure sources.
      /// </summary>
      /// <remarks>  This filter takes the output from "SHOW CREATE PROCEDURE <procname>" and transforms it into a ProcedureSources schema table.
      /// </remarks>
            
      /// <summary>  MySqlProcedureSourcesCursor is a filter for a cursor providing procedure sources.
      /// </summary>
      /// <remarks>  This filter takes the output from "SHOW CREATE PROCEDURE <procname>" and transforms it into a ProcedureSources schema table.
      /// </remarks>
      TDBXMySqlProcedureSourcesCursor = class(TDBXBaseMetaDataReader.TDBXSanitizedTableCursor)
      public
        destructor Destroy; override;
        function Next: Boolean; override;
        procedure Close; override;
        function IsNull(Ordinal: Integer): Boolean; override;
        function GetString(Ordinal: Integer): WideString; override;
      protected
        constructor Create(const Reader: TDBXMySqlCustomMetaDataReader; const Columns: TDBXColumnDescriptorArray; const Sql: WideString; const SchemaName: WideString; const ProcedureName: WideString);
        function FindStringSize(const Ordinal: Integer; const SourceColumns: TDBXColumnDescriptorArray): Integer; override;
      private
        function InitNextCursor: Boolean;
        function ComputeDefinition: WideString;
        function ComputeDefiner: WideString;
      private
        FReader: TDBXMySqlCustomMetaDataReader;
        FProcedures: TDBXStringList;
        FProcedureTypes: TDBXStringList;
        FProcedureIndex: Integer;
        FSql: WideString;
        FProcedureName: WideString;
        FProcedureType: WideString;
        FDefiner: WideString;
      private
        const ShowCreateProcedureSqlOrdinal = 2;
        const DefinerString = 'DEFINER=';
      end;

      TDBXMySqlProcedureParametersCursor = class(TDBXBaseMetaDataReader.TDBXSanitizedTableCursor)
      public
        destructor Destroy; override;
        function Next: Boolean; override;
        procedure Close; override;
        function IsNull(Ordinal: Integer): Boolean; override;
        function GetString(Ordinal: Integer): WideString; override;
        function GetInt32(Ordinal: Integer): Integer; override;
        function GetBoolean(Ordinal: Integer): Boolean; override;
      protected
        constructor Create(const Reader: TDBXMySqlCustomMetaDataReader; const Columns: TDBXColumnDescriptorArray; const Sql: WideString; const SchemaName: WideString; const ProcedureName: WideString; const ParameterName: WideString);
        function FindStringSize(const Ordinal: Integer; const SourceColumns: TDBXColumnDescriptorArray): Integer; override;
      private
        function InitNextCursor: Boolean;
        procedure ComputeParams;
      private
        FReader: TDBXMySqlCustomMetaDataReader;
        FProcedures: TDBXStringList;
        FProcedureTypes: TDBXStringList;
        FProcedureIndex: Integer;
        FParameterIndex: Integer;
        FSql: WideString;
        FProcedureName: WideString;
        FParameterName: WideString;
        FProcedureType: WideString;
        FDefiner: WideString;
        FParams: TDBXArrayList;
        FParameter: TDBXMySqlCustomMetaDataReader.TDBXMySqlParameter;
      private
        const ShowCreateProcedureSqlOrdinal = 2;
        const DefinerString = 'DEFINER=';
      end;

  public
    destructor Destroy; override;
    
    /// <summary>  Overrides the implementation in BaseMetaDataReader.
    /// </summary>
    /// <remarks>  Allthough MySQL does not support schemas, catalogs are reported as schemas
    ///   in MySQL version 5.
    /// </remarks>
    function FetchSchemas(const Catalog: WideString): TDBXTableStorage; override;
    
    /// <summary>  Overrides the implementation in BaseMetaDataReader.
    /// </summary>
    /// <remarks>  Use a special filter for MySQL 4 to convert output from "SHOW TABLES".
    /// </remarks>
    function FetchTables(const Catalog: WideString; const Schema: WideString; const TableName: WideString; const TableType: WideString): TDBXTableStorage; override;
    
    /// <summary>  Overrides the implementation in BaseMetaDataReader.
    /// </summary>
    /// <remarks>  Note: views did not exist in MySQL prior to version 5.
    /// </remarks>
    function FetchViews(const Catalog: WideString; const Schema: WideString; const View: WideString): TDBXTableStorage; override;
    
    /// <summary>  Overrides the implementation in BaseMetaDataReader.
    /// </summary>
    /// <remarks>  Use a special filter for MySQL 4 to convert output from "SHOW COLUMNS FROM <tablename>".
    /// </remarks>
    /// <seealso cref="MySql4ColumnsCursor."/>
    function FetchColumns(const Catalog: WideString; const Schema: WideString; const Table: WideString): TDBXTableStorage; override;
    
    /// <summary>  Overrides the implementation in BaseMetaDataReader.
    /// </summary>
    /// <remarks>  Use a special filter for MySQL 4 to convert output from "SHOW INDEX FROM <tablename>".
    /// </remarks>
    /// <seealso cref="MySql4IndexesCursor."/>
    function FetchIndexes(const Catalog: WideString; const Schema: WideString; const Table: WideString): TDBXTableStorage; override;
    
    /// <summary>  Overrides the implementation in BaseMetaDataReader.
    /// </summary>
    /// <remarks>  Use a special filter for MySQL 4 to convert output from "SHOW INDEX FROM <tablename>".
    /// </remarks>
    /// <seealso cref="MySql4IndexColumnsCursor."/>
    function FetchIndexColumns(const Catalog: WideString; const Schema: WideString; const Table: WideString; const Index: WideString): TDBXTableStorage; override;
    function FetchForeignKeys(const Catalog: WideString; const Schema: WideString; const Table: WideString): TDBXTableStorage; override;
    function FetchForeignKeyColumns(const Catalog: WideString; const Schema: WideString; const Table: WideString; const ForeignKeyName: WideString; const PrimaryCatalog: WideString; const PrimarySchema: WideString; const PrimaryTable: WideString; const PrimaryKeyName: WideString): TDBXTableStorage; override;
    function FetchProcedures(const Catalog: WideString; const Schema: WideString; const ProcedureName: WideString; const ProcType: WideString): TDBXTableStorage; override;
    function FetchProcedureSources(const Catalog: WideString; const Schema: WideString; const &Procedure: WideString): TDBXTableStorage; override;
    function FetchProcedureParameters(const Catalog: WideString; const Schema: WideString; const &Procedure: WideString; const Parameter: WideString): TDBXTableStorage; override;
    function FetchUsers: TDBXTableStorage; override;
  protected
    procedure SetContext(const Context: TDBXProviderContext); override;
    function IsDefaultCharSetUnicode: Boolean; virtual;
    procedure PopulateDataTypes(Hash: TDBXObjectStore; Types: TDBXArrayList; const Descr: TDBXDataTypeDescriptionArray); override;
    function GetTables: TDBXStringList;
    function FindDataType(const TypeName: WideString): Integer; virtual;
  private
    procedure InitScanner;
    procedure GetProcedures(const SchemaName: WideString; const ProcedureName: WideString; const Procedures: TDBXStringList; const ProcedureTypes: TDBXStringList);
    function ParseProcedureDefiner(const Definition: WideString): WideString;
    procedure ParseProcedure(const Definition: WideString; const &Type: WideString; Params: TDBXArrayList);
    function ParseType(const Definition: WideString; &Type: TDBXMySqlCustomMetaDataReader.TDBXMySqlColumnType): Integer;
    function ReplaceIdentifier(Sql: WideString; ParameterName: WideString; ActualValue: WideString; MakeQuotes: Boolean): WideString;
    function ToInt(const Value: WideString): Integer;
    function ParseIdList(const Scanner: TDBXSqlScanner; const List: TDBXStringList): Boolean;
    function ParseForeignKey(const Scanner: TDBXSqlScanner; const ForeignKey: TDBXMySqlCustomMetaDataReader.TDBXMySqlForeignKey): Boolean;
    function ParseCreateTableForNextForeignKey(const Sql: WideString; StartIndex: Integer; const Key: TDBXMySqlCustomMetaDataReader.TDBXMySqlForeignKey): Integer;
  protected
    FScanner: TDBXSqlScanner;
  private
    FDefaultCharSetIsUnicode: Boolean;
  public
    property DefaultCharSetUnicode: Boolean read IsDefaultCharSetUnicode;
  private
    property Tables: TDBXStringList read GetTables;
  private
    const DefaultCharsetIsUnicode = 'UnicodeEncoding';
    const YForYes = 'Y';
    const AForAscending = 'A';
    const FAuto_increment = 'auto_increment';
    const IntegerType = 'integer';
    const IntType = 'int';
    const DecimalType = 'decimal';
    const DecType = 'dec';
    const Table = 'TABLE';
    const Constraint = 'CONSTRAINT';
    const Foreign = 'FOREIGN';
    const Key = 'KEY';
    const References = 'REFERENCES';
    const Quote = '''';
    const FYear = 'year';
    const CurrentTimestamp = 'CURRENT_TIMESTAMP';
    const Primary = 'PRIMARY';
    const &Procedure = 'PROCEDURE';
    const &Function = 'FUNCTION';
    const &Begin = 'BEGIN';
    const &Create = 'CREATE';
    const Definer = 'DEFINER';
    const Returns = 'RETURNS';
    const Character = 'CHARACTER';
    const &Set = 'SET';
    const Utf8 = 'utf8';
    const &In = 'IN';
    const Out = 'OUT';
    const Inout = 'INOUT';
    const Unsigned = 'UNSIGNED';
    const &Not = 'NOT';
    const NullSpec = 'NULL';
    const Binary = 'BINARY';
    const Varbinary = 'VARBINARY';
    const DefaultVarcharPrecision = 128;
    const TokenProcedure = 1;
    const TokenFunction = 2;
    const TokenReturns = 3;
    const TokenBegin = 4;
    const TokenIn = 5;
    const TokenOut = 6;
    const TokenInout = 7;
    const TokenCharacter = 8;
    const TokenSet = 9;
    const TokenUtf8 = 10;
    const TokenUnsigned = 11;
    const TokenCreate = 12;
    const TokenDefiner = 13;
    const TokenNot = 14;
    const TokenNull = 15;
    const TokenBinary = 16;
  end;

  TDBXMySqlMetaDataReader = class(TDBXMySqlCustomMetaDataReader)
  public
    function FetchCatalogs: TDBXTableStorage; override;
    function FetchSchemas(const CatalogName: WideString): TDBXTableStorage; override;
    function FetchColumnConstraints(const CatalogName: WideString; const SchemaName: WideString; const TableName: WideString): TDBXTableStorage; override;
    function FetchSynonyms(const CatalogName: WideString; const SchemaName: WideString; const SynonymName: WideString): TDBXTableStorage; override;
    function FetchPackages(const CatalogName: WideString; const SchemaName: WideString; const PackageName: WideString): TDBXTableStorage; override;
    function FetchPackageProcedures(const CatalogName: WideString; const SchemaName: WideString; const PackageName: WideString; const ProcedureName: WideString; const ProcedureType: WideString): TDBXTableStorage; override;
    function FetchPackageProcedureParameters(const CatalogName: WideString; const SchemaName: WideString; const PackageName: WideString; const ProcedureName: WideString; const ParameterName: WideString): TDBXTableStorage; override;
    function FetchPackageSources(const CatalogName: WideString; const SchemaName: WideString; const PackageName: WideString): TDBXTableStorage; override;
    function FetchRoles: TDBXTableStorage; override;
  protected
    function GetProductName: WideString; override;
    function GetSqlIdentifierQuotePrefix: WideString; override;
    function GetSqlIdentifierQuoteSuffix: WideString; override;
    function GetSqlIdentifierQuoteChar: WideString; override;
    function GetTableType: WideString; override;
    function IsDescendingIndexColumnsSupported: Boolean; override;
    function IsLowerCaseIdentifiersSupported: Boolean; override;
    function IsUpperCaseIdentifiersSupported: Boolean; override;
    function IsMultipleCommandsSupported: Boolean; override;
    function GetSqlForTables: WideString; override;
    function GetSqlForViews: WideString; override;
    function GetSqlForColumns: WideString; override;
    function GetSqlForIndexes: WideString; override;
    function GetSqlForIndexColumns: WideString; override;
    function GetSqlForForeignKeys: WideString; override;
    function GetSqlForForeignKeyColumns: WideString; override;
    function GetSqlForProcedures: WideString; override;
    function GetSqlForProcedureSources: WideString; override;
    function GetSqlForProcedureParameters: WideString; override;
    function GetSqlForUsers: WideString; override;
    function GetDataTypeDescriptions: TDBXDataTypeDescriptionArray; override;
    function GetReservedWords: TDBXWideStringArray; override;
  end;

implementation
uses
  DBXCommon,
  DBXMetaDataUtil,
  StrUtils,
  SysUtils;

destructor TDBXMySqlCustomMetaDataReader.Destroy;
begin
  FreeAndNil(FScanner);
  inherited Destroy;
end;

procedure TDBXMySqlCustomMetaDataReader.SetContext(const Context: TDBXProviderContext);
begin
  inherited SetContext(Context);
  FDefaultCharSetIsUnicode := (Context.GetVendorProperty(DefaultCharsetIsUnicode) = 'true');
end;

function TDBXMySqlCustomMetaDataReader.IsDefaultCharSetUnicode: Boolean;
begin
  Result := FDefaultCharSetIsUnicode;
end;

procedure TDBXMySqlCustomMetaDataReader.PopulateDataTypes(Hash: TDBXObjectStore; Types: TDBXArrayList; const Descr: TDBXDataTypeDescriptionArray);
var
  Index: Integer;
  DataType: TDBXDataTypeDescription;
begin
  if FDefaultCharSetIsUnicode or (CompareVersion(TDBXVersion.FMySQL5) >= 0) then
    for index := 0 to Length(Descr) - 1 do
    begin
      DataType := Descr[Index];
      if DataType.DbxDataType = TDBXDataTypes.AnsiStringType then
        DataType.UnicodeOptionSupported := True;
    end;
  inherited PopulateDataTypes(Hash, Types, Descr);
end;

function TDBXMySqlCustomMetaDataReader.FetchSchemas(const Catalog: WideString): TDBXTableStorage;
var
  Columns: TDBXColumnDescriptorArray;
begin
  if CompareVersion(TDBXVersion.FMySQL5) >= 0 then
    Result := inherited FetchSchemas(Catalog)
  else 
  begin
    Columns := TDBXMetaDataCollectionColumns.CreateSchemasColumns;
    Result := TDBXBaseMetaDataReader.TDBXEmptyTableCursor.Create(TDBXMetaDataCollectionIndex.Schemas, TDBXMetaDataCollectionName.Schemas, Columns);
  end;
end;

function TDBXMySqlCustomMetaDataReader.FetchTables(const Catalog: WideString; const Schema: WideString; const TableName: WideString; const TableType: WideString): TDBXTableStorage;
var
  Columns: TDBXColumnDescriptorArray;
  Sql: WideString;
  Cursor: TDBXTableStorage;
begin
  if CompareVersion(TDBXVersion.FMySQL5) >= 0 then
  begin
    Result := inherited FetchTables(Catalog, Schema, TableName, TableType);
    exit;
  end;
  Columns := TDBXMetaDataCollectionColumns.CreateTablesColumns;
  if (not StringIsNil(TableType)) and (StringIndexOf(TableType,Table) < 0) then
    Result := TDBXBaseMetaDataReader.TDBXEmptyTableCursor.Create(TDBXMetaDataCollectionIndex.Tables, TDBXMetaDataCollectionName.Tables, Columns)
  else 
  begin
    Sql := SqlForTables;
    if not StringIsNil(TableName) then
      Sql := Sql + ' like ''' + TableName + '''';
    Cursor := FContext.ExecuteQuery(Sql, nil, nil);
    Result := TDBXMySqlCustomMetaDataReader.TDBXMySql4TablesCursor.Create(self, Columns, Cursor);
  end;
end;

function TDBXMySqlCustomMetaDataReader.FetchViews(const Catalog: WideString; const Schema: WideString; const View: WideString): TDBXTableStorage;
var
  Columns: TDBXColumnDescriptorArray;
begin
  if CompareVersion(TDBXVersion.FMySQL5) >= 0 then
    Result := inherited FetchViews(Catalog, Schema, View)
  else 
  begin
    Columns := TDBXMetaDataCollectionColumns.CreateViewsColumns;
    Result := TDBXBaseMetaDataReader.TDBXEmptyTableCursor.Create(TDBXMetaDataCollectionIndex.Views, TDBXMetaDataCollectionName.Views, Columns);
  end;
end;

function TDBXMySqlCustomMetaDataReader.FetchColumns(const Catalog: WideString; const Schema: WideString; const Table: WideString): TDBXTableStorage;
var
  Columns: TDBXColumnDescriptorArray;
  ParameterNames: TDBXWideStringArray;
  ParameterValues: TDBXWideStringArray;
  Original: TDBXTableStorage;
  Sanitized: TDBXTableStorage;
  Original4: TDBXTableStorage;
begin
  Columns := TDBXMetaDataCollectionColumns.CreateColumnsColumns;
  if CompareVersion(TDBXVersion.FMySQL5) >= 0 then
  begin
    SetLength(ParameterNames,3);
    ParameterNames[0] := TDBXParameterName.CatalogName;
    ParameterNames[1] := TDBXParameterName.SchemaName;
    ParameterNames[2] := TDBXParameterName.TableName;
    SetLength(ParameterValues,3);
    ParameterValues[0] := Catalog;
    ParameterValues[1] := Schema;
    ParameterValues[2] := Table;
    Original := FContext.ExecuteQuery(SqlForColumns, ParameterNames, ParameterValues);
    Sanitized := TDBXBaseMetaDataReader.TDBXSanitizedTableCursor.Create(FContext, TDBXMetaDataCollectionIndex.Columns, TDBXMetaDataCollectionName.Columns, Columns, Original);
    Result := TDBXMySqlCustomMetaDataReader.TDBXMySqlColumnsTableCursor.Create(self, True, Original, Sanitized);
  end
  else 
  begin
    Original4 := TDBXMySqlCustomMetaDataReader.TDBXMySql4ColumnsCursor.Create(self, Columns, SqlForColumns, Table);
    Result := TDBXMySqlCustomMetaDataReader.TDBXMySqlColumnsTableCursor.Create(self, False, Original4, Original4);
  end;
end;

function TDBXMySqlCustomMetaDataReader.FetchIndexes(const Catalog: WideString; const Schema: WideString; const Table: WideString): TDBXTableStorage;
var
  Columns: TDBXColumnDescriptorArray;
begin
  if CompareVersion(TDBXVersion.FMySQL5) >= 0 then
  begin
    Result := inherited FetchIndexes(Catalog, Schema, Table);
    exit;
  end;
  Columns := TDBXMetaDataCollectionColumns.CreateIndexesColumns;
  Result := TDBXMySqlCustomMetaDataReader.TDBXMySql4IndexesCursor.Create(self, Columns, SqlForIndexes, Table);
end;

function TDBXMySqlCustomMetaDataReader.FetchIndexColumns(const Catalog: WideString; const Schema: WideString; const Table: WideString; const Index: WideString): TDBXTableStorage;
var
  Columns: TDBXColumnDescriptorArray;
begin
  if CompareVersion(TDBXVersion.FMySQL5) >= 0 then
  begin
    Result := inherited FetchIndexColumns(Catalog, Schema, Table, Index);
    exit;
  end;
  Columns := TDBXMetaDataCollectionColumns.CreateIndexColumnsColumns;
  Result := TDBXMySqlCustomMetaDataReader.TDBXMySql4IndexColumnsCursor.Create(self, Columns, SqlForIndexColumns, Table, Index);
end;

function TDBXMySqlCustomMetaDataReader.FetchForeignKeys(const Catalog: WideString; const Schema: WideString; const Table: WideString): TDBXTableStorage;
var
  Columns: TDBXColumnDescriptorArray;
begin
  if CompareVersion(TDBXVersion.FMySQL5) >= 0 then
  begin
    Result := inherited FetchForeignKeys(Catalog, Schema, Table);
    exit;
  end;
  Columns := TDBXMetaDataCollectionColumns.CreateForeignKeysColumns;
  Result := TDBXMySqlCustomMetaDataReader.TDBXMySql4ForeignKeyCursor.Create(self, Columns, SqlForForeignKeys, Table);
end;

function TDBXMySqlCustomMetaDataReader.FetchForeignKeyColumns(const Catalog: WideString; const Schema: WideString; const Table: WideString; const ForeignKeyName: WideString; const PrimaryCatalog: WideString; const PrimarySchema: WideString; const PrimaryTable: WideString; const PrimaryKeyName: WideString): TDBXTableStorage;
var
  Columns: TDBXColumnDescriptorArray;
begin
  if CompareVersion(TDBXVersion.FMySQL5_0_6) >= 0 then
  begin
    Result := inherited FetchForeignKeyColumns(Catalog, Schema, Table, ForeignKeyName, PrimaryCatalog, PrimarySchema, PrimaryTable, PrimaryKeyName);
    exit;
  end;
  Columns := TDBXMetaDataCollectionColumns.CreateForeignKeyColumnsColumns;
  Result := TDBXMySqlCustomMetaDataReader.TDBXMySql4ForeignKeyColumnsCursor.Create(self, Columns, SqlForForeignKeys, Table, ForeignKeyName, PrimaryTable, PrimaryKeyName);
end;

function TDBXMySqlCustomMetaDataReader.FetchProcedures(const Catalog: WideString; const Schema: WideString; const ProcedureName: WideString; const ProcType: WideString): TDBXTableStorage;
var
  Columns: TDBXColumnDescriptorArray;
begin
  if CompareVersion(TDBXVersion.FMySQL5_0_6) >= 0 then
    Result := inherited FetchProcedures(Catalog, Schema, ProcedureName, ProcType)
  else 
  begin
    Columns := TDBXMetaDataCollectionColumns.CreateProceduresColumns;
    Result := TDBXBaseMetaDataReader.TDBXEmptyTableCursor.Create(TDBXMetaDataCollectionIndex.Procedures, TDBXMetaDataCollectionName.Procedures, Columns);
  end;
end;

function TDBXMySqlCustomMetaDataReader.FetchProcedureSources(const Catalog: WideString; const Schema: WideString; const &Procedure: WideString): TDBXTableStorage;
var
  Columns: TDBXColumnDescriptorArray;
begin
  Columns := TDBXMetaDataCollectionColumns.CreateProcedureSourcesColumns;
  if CompareVersion(TDBXVersion.FMySQL5_0_6) >= 0 then
    Result := TDBXMySqlCustomMetaDataReader.TDBXMySqlProcedureSourcesCursor.Create(self, Columns, SqlForProcedureSources, Schema, &Procedure)
  else 
    Result := TDBXBaseMetaDataReader.TDBXEmptyTableCursor.Create(TDBXMetaDataCollectionIndex.ProcedureSources, TDBXMetaDataCollectionName.ProcedureSources, Columns);
end;

function TDBXMySqlCustomMetaDataReader.FetchProcedureParameters(const Catalog: WideString; const Schema: WideString; const &Procedure: WideString; const Parameter: WideString): TDBXTableStorage;
var
  Columns: TDBXColumnDescriptorArray;
begin
  Columns := TDBXMetaDataCollectionColumns.CreateProcedureParametersColumns;
  if CompareVersion(TDBXVersion.FMySQL5_0_6) >= 0 then
    Result := TDBXBaseMetaDataReader.TDBXColumnsTableCursor.Create(self, True, TDBXMySqlCustomMetaDataReader.TDBXMySqlProcedureParametersCursor.Create(self, Columns, SqlForProcedureSources, Schema, &Procedure, Parameter))
  else 
    Result := TDBXBaseMetaDataReader.TDBXEmptyTableCursor.Create(TDBXMetaDataCollectionIndex.ProcedureParameters, TDBXMetaDataCollectionName.ProcedureParameters, Columns);
end;

function TDBXMySqlCustomMetaDataReader.FetchUsers: TDBXTableStorage;
var
  Columns: TDBXColumnDescriptorArray;
begin
  if CompareVersion(TDBXVersion.FMySQL5) >= 0 then
    Result := inherited FetchUsers
  else 
  begin
    Columns := TDBXMetaDataCollectionColumns.CreateUsersColumns;
    Result := TDBXBaseMetaDataReader.TDBXEmptyTableCursor.Create(TDBXMetaDataCollectionIndex.Users, TDBXMetaDataCollectionName.Users, Columns);
  end;
end;

procedure TDBXMySqlCustomMetaDataReader.InitScanner;
var
  Scan: TDBXSqlScanner;
begin
  if FScanner = nil then
  begin
    Scan := TDBXSqlScanner.Create(SqlIdentifierQuoteChar, SqlIdentifierQuotePrefix, SqlIdentifierQuoteSuffix);
    Scan.RegisterId(&Procedure, TokenProcedure);
    Scan.RegisterId(&Function, TokenFunction);
    Scan.RegisterId(Returns, TokenReturns);
    Scan.RegisterId(&Begin, TokenBegin);
    Scan.RegisterId(&In, TokenIn);
    Scan.RegisterId(Out, TokenOut);
    Scan.RegisterId(Inout, TokenInout);
    Scan.RegisterId(Character, TokenCharacter);
    Scan.RegisterId(&Set, TokenSet);
    Scan.RegisterId(Utf8, TokenUtf8);
    Scan.RegisterId(Unsigned, TokenUnsigned);
    Scan.RegisterId(&Create, TokenCreate);
    Scan.RegisterId(Definer, TokenDefiner);
    Scan.RegisterId(&Not, TokenNot);
    Scan.RegisterId(NullSpec, TokenNull);
    Scan.RegisterId(Binary, TokenBinary);
    FScanner := Scan;
  end;
end;

procedure TDBXMySqlCustomMetaDataReader.GetProcedures(const SchemaName: WideString; const ProcedureName: WideString; const Procedures: TDBXStringList; const ProcedureTypes: TDBXStringList);
var
  Cursor: TDBXTableStorage;
begin
  Cursor := FetchProcedures(NullString, SchemaName, ProcedureName, NullString);
  while Cursor.Next do
  begin
    Procedures.Add(Cursor.GetAsString(TDBXProceduresIndex.ProcedureName));
    ProcedureTypes.Add(Cursor.GetAsString(TDBXProceduresIndex.ProcedureType));
  end;
  Cursor.Close;
  Cursor.Free;
end;

// CREATE DEFINER=`barney`@`%` FUNCTION `f1`(param1 INT) RETURNS int(11) begin   return param1+1; end
// CREATE DEFINER=`barney`@`%` PROCEDURE `simpleproc`(OUT param1 INT) begin   select count(*) into param1 from joal_t1; end
function TDBXMySqlCustomMetaDataReader.ParseProcedureDefiner(const Definition: WideString): WideString;
var
  Definer: WideString;
  Token: Integer;
begin
  InitScanner;
  FScanner.Init(Definition);
  Definer := NullString;
  Token := FScanner.NextToken;
  if Token = TokenCreate then
  begin
    Token := FScanner.NextToken;
    if Token = TokenDefiner then
    begin
      Token := FScanner.NextToken;
      if (Token = TDBXSqlScanner.TokenSymbol) and (FScanner.Symbol = '=') then
      begin
        Token := FScanner.NextToken;
        if Token = TDBXSqlScanner.TokenId then
          Definer := FScanner.Id;
      end;
    end;
  end;
  Result := Definer;
end;

procedure TDBXMySqlCustomMetaDataReader.ParseProcedure(const Definition: WideString; const &Type: WideString; Params: TDBXArrayList);
var
  ReturnType: TDBXMySqlCustomMetaDataReader.TDBXMySqlParameter;
  Ordinal: Integer;
  Token: Integer;
  Param: TDBXMySqlCustomMetaDataReader.TDBXMySqlParameter;
begin
  Params.Clear;
  ReturnType := nil;
  if (&Type = &Function) then
  begin
    ReturnType := TDBXMySqlCustomMetaDataReader.TDBXMySqlParameter.Create;
    ReturnType.FName := 'RETURN_VALUE';
    ReturnType.FMode := 'RESULT';
    ReturnType.FOrdinal := 0;
    Params.Add(ReturnType);
  end;
  InitScanner;
  FScanner.Init(Definition);
  Ordinal := 1;
  Token := TDBXSqlScanner.TokenId;
  while Token <> TDBXSqlScanner.TokenOpenParen do
    Token := FScanner.NextToken;
  Token := TDBXSqlScanner.TokenComma;
  while Token = TDBXSqlScanner.TokenComma do
  begin
    Param := TDBXMySqlCustomMetaDataReader.TDBXMySqlParameter.Create;
    Param.FMode := &In;
    Token := FScanner.NextToken;
    if (Token = TokenIn) or (Token = TokenOut) or (Token = TokenInout) then
    begin
      Param.FMode := FScanner.Id;
      Token := FScanner.NextToken;
    end;
    ;
    Param.FName := FScanner.Id;
    Param.FOrdinal := Ordinal;
    Token := ParseType(NullString, Param);
    Params.Add(Param);
    IncrAfter(Ordinal);
  end;
  ;
  Token := FScanner.NextToken;
  if (ReturnType <> nil) and (Token = TokenReturns) then
    ParseType(NullString, ReturnType);
end;

function TDBXMySqlCustomMetaDataReader.ParseType(const Definition: WideString; &Type: TDBXMySqlCustomMetaDataReader.TDBXMySqlColumnType): Integer;
var
  Token: Integer;
begin
  if not StringIsNil(Definition) then
  begin
    InitScanner;
    FScanner.Init(Definition);
  end;
  FScanner.NextToken;
  &Type.FDataType := WideLowerCase(FScanner.Id);
  &Type.FPrecision := 0;
  &Type.FScale := 0;
  &Type.FUnsigned := False;
  &Type.FUnicode := False;
  &Type.FNotnull := False;
  if (&Type.FDataType = IntegerType) then
    &Type.FDataType := IntType;
  if (&Type.FDataType = DecType) then
    &Type.FDataType := DecimalType;
  Token := FScanner.NextToken;
  if Token = TDBXSqlScanner.TokenOpenParen then
  begin
    Token := FScanner.NextToken;
    if Token = TDBXSqlScanner.TokenNumber then
    begin
      &Type.FPrecision := ToInt(FScanner.Id);
      Token := FScanner.NextToken;
      if Token = TDBXSqlScanner.TokenComma then
      begin
        Token := FScanner.NextToken;
        if Token = TDBXSqlScanner.TokenNumber then
        begin
          &Type.FScale := ToInt(FScanner.Id);
          Token := FScanner.NextToken;
        end;
      end;
    end;
    while Token <> TDBXSqlScanner.TokenCloseParen do
      Token := FScanner.NextToken;
    Token := FScanner.NextToken;
  end;
  while True do
  begin
    case Token of
      TokenBegin,
      TDBXSqlScanner.TokenEos,
      TDBXSqlScanner.TokenComma:
        begin
          Result := Token;
          exit;
        end;
      TokenUnsigned:
        &Type.FUnsigned := True;
      TokenUtf8:
        &Type.FUnicode := True;
      TokenBinary:
        if (&Type.FDataType = 'varchar') then
          &Type.FDataType := WideLowerCase(Varbinary)
        else if (&Type.FDataType = 'char') then
          &Type.FDataType := WideLowerCase(Binary);
      TokenNot:
        begin
          Token := FScanner.NextToken;
          if Token = TokenNull then
            &Type.FNotnull := False
          else if (Token = TDBXSqlScanner.TokenComma) or (Token = TokenBegin) then
          begin
            Result := Token;
            exit;
          end;
        end;
    end;
    Token := FScanner.NextToken;
  end;
end;

function TDBXMySqlCustomMetaDataReader.GetTables: TDBXStringList;
var
  Cursor: TDBXTableStorage;
  Tables: TDBXStringList;
begin
  Cursor := FContext.ExecuteQuery(SqlForTables, nil, nil);
  Tables := TDBXStringList.Create;
  while Cursor.Next do
    Tables.Add(Cursor.GetAsString(0));
  Cursor.Close;
  Cursor.Free;
  Result := Tables;
end;

function TDBXMySqlCustomMetaDataReader.FindDataType(const TypeName: WideString): Integer;
var
  Hash: TDBXObjectStore;
  DataType: TDBXDataTypeDescription;
begin
  Hash := DataTypeHash;
  DataType := TDBXDataTypeDescription(Hash[TypeName]);
  if DataType <> nil then
    Result := DataType.DbxDataType
  else 
    Result := TDBXDataTypes.UnknownType;
end;

function TDBXMySqlCustomMetaDataReader.ReplaceIdentifier(Sql: WideString; ParameterName: WideString; ActualValue: WideString; MakeQuotes: Boolean): WideString;
var
  ParameterStart: Integer;
  ParameterEnd: Integer;
  Value: WideString;
begin
  ParameterStart := StringLastIndexOf(Sql,ParameterName);
  ParameterEnd := ParameterStart + Length(ParameterName);
  Value := Sql;
  if (ParameterStart > 0) and (Sql[1+ParameterStart - 1] = SqlDefaultParameterMarker[1+0]) then
  begin
    Decr(ParameterStart);
    Value := ActualValue;
    if MakeQuotes then
      Value := TDBXMetaDataUtil.QuoteIdentifier(Value, SqlIdentifierQuoteChar, SqlIdentifierQuotePrefix, SqlIdentifierQuoteSuffix);
    Value := Copy(Sql,0+1,ParameterStart-(0)) + Value + Copy(Sql,ParameterEnd+1,Length(Sql)-(ParameterEnd));
  end;
  Result := Value;
end;

function TDBXMySqlCustomMetaDataReader.ToInt(const Value: WideString): Integer;
begin
  try
    Result := StrToInt(Value);
  except
    on Ex: Exception do
      Result := -1;
  end;
end;

function TDBXMySqlCustomMetaDataReader.ParseIdList(const Scanner: TDBXSqlScanner; const List: TDBXStringList): Boolean;
var
  Token: Integer;
begin
  Token := Scanner.NextToken;
  if Token <> TDBXSqlScanner.TokenOpenParen then
  begin
    Result := False;
    exit;
  end;
  Token := Scanner.NextToken;
  if Token <> TDBXSqlScanner.TokenId then
  begin
    Result := False;
    exit;
  end;
  List.Add(Scanner.Id);
  Token := Scanner.NextToken;
  while Token = TDBXSqlScanner.TokenComma do
  begin
    Token := Scanner.NextToken;
    if Token <> TDBXSqlScanner.TokenId then
    begin
      Result := False;
      exit;
    end;
    List.Add(Scanner.Id);
    Token := Scanner.NextToken;
  end;
  if Token <> TDBXSqlScanner.TokenCloseParen then
  begin
    Result := False;
    exit;
  end;
  Result := True;
end;

function TDBXMySqlCustomMetaDataReader.ParseForeignKey(const Scanner: TDBXSqlScanner; const ForeignKey: TDBXMySqlCustomMetaDataReader.TDBXMySqlForeignKey): Boolean;
var
  Token: Integer;
begin
  Scanner.NextToken;
  if not Scanner.IsKeyword(Constraint) then
  begin
    Result := False;
    exit;
  end;
  Token := Scanner.NextToken;
  if Token <> TDBXSqlScanner.TokenId then
  begin
    Result := False;
    exit;
  end;
  ForeignKey.FConstraintName := Scanner.Id;
  Scanner.NextToken;
  if not Scanner.IsKeyword(Foreign) then
  begin
    Result := False;
    exit;
  end;
  Scanner.NextToken;
  if not Scanner.IsKeyword(Key) then
  begin
    Result := False;
    exit;
  end;
  if not ParseIdList(Scanner, ForeignKey.FKeyColumns) then
  begin
    Result := False;
    exit;
  end;
  Scanner.NextToken;
  if not Scanner.IsKeyword(References) then
  begin
    Result := False;
    exit;
  end;
  Token := Scanner.NextToken;
  if Token <> TDBXSqlScanner.TokenId then
  begin
    Result := False;
    exit;
  end;
  ForeignKey.FReferencedTableName := Scanner.Id;
  Result := ParseIdList(Scanner, ForeignKey.FReferencedColumns);
end;

function TDBXMySqlCustomMetaDataReader.ParseCreateTableForNextForeignKey(const Sql: WideString; StartIndex: Integer; const Key: TDBXMySqlCustomMetaDataReader.TDBXMySqlForeignKey): Integer;
var
  Index: Integer;
begin
  Index := StringIndexOf(Sql,Constraint,StartIndex);
  InitScanner;
  while Index > 0 do
  begin
    StartIndex := Index + Length(Constraint);
    FScanner.Init(Sql, Index);
    Key.Reset;
    if ParseForeignKey(FScanner, Key) then
    begin
      FreeAndNil(FScanner);
      begin
        Result := StartIndex;
        exit;
      end;
    end;
    Index := StringIndexOf(Sql,Constraint,StartIndex);
  end;
  FreeAndNil(FScanner);
  Result := -1;
end;

constructor TDBXMySqlCustomMetaDataReader.TDBXMySqlForeignKey.Create;
begin
  inherited Create;
  FKeyColumns := TDBXStringList.Create;
  FReferencedColumns := TDBXStringList.Create;
end;

destructor TDBXMySqlCustomMetaDataReader.TDBXMySqlForeignKey.Destroy;
begin
  FreeAndNil(FKeyColumns);
  FreeAndNil(FReferencedColumns);
  inherited Destroy;
end;

procedure TDBXMySqlCustomMetaDataReader.TDBXMySqlForeignKey.Reset;
begin
  FConstraintName := NullString;
  FKeyColumns.Clear;
  FReferencedColumns.Clear;
end;

constructor TDBXMySqlCustomMetaDataReader.TDBXMySql4TablesCursor.Create(const Reader: TDBXMySqlCustomMetaDataReader; const Columns: TDBXColumnDescriptorArray; const Cursor: TDBXTableStorage);
begin
  inherited Create(Reader.FContext, TDBXMetaDataCollectionIndex.Tables, TDBXMetaDataCollectionName.Tables, Columns, Cursor);
end;

function TDBXMySqlCustomMetaDataReader.TDBXMySql4TablesCursor.FindStringSize(const Ordinal: Integer; const SourceColumns: TDBXColumnDescriptorArray): Integer;
begin
  case Ordinal of
    TDBXTablesIndex.TableName:
      Result := SourceColumns[ShowTablesTableNameOrdinal].DataSize;
    else
      Result := DefaultVarcharPrecision;
  end;
end;

function TDBXMySqlCustomMetaDataReader.TDBXMySql4TablesCursor.IsNull(Ordinal: Integer): Boolean;
begin
  Result := ((Ordinal <> TDBXTablesIndex.TableName) and (Ordinal <> TDBXTablesIndex.TableType));
end;

function TDBXMySqlCustomMetaDataReader.TDBXMySql4TablesCursor.GetString(Ordinal: Integer): WideString;
begin
  case Ordinal of
    TDBXTablesIndex.TableName:
      Result := inherited GetString(ShowTablesTableNameOrdinal);
    TDBXTablesIndex.TableType:
      Result := Table;
    else
      Result := NullString;
  end;
end;

constructor TDBXMySqlCustomMetaDataReader.TDBXMySqlColumnsTableCursor.Create(Reader: TDBXMySqlCustomMetaDataReader; Version5: Boolean; Original: TDBXTableStorage; Sanitized: TDBXTableStorage);
begin
  inherited Create(Reader, False, Sanitized);
  self.FOriginal := Original;
  self.FVersion5 := Version5;
end;

function TDBXMySqlCustomMetaDataReader.TDBXMySqlColumnsTableCursor.GetInt32(Ordinal: Integer): Integer;
var
  Value: Integer;
  IsUnsigned: Boolean;
begin
  Value := inherited GetInt32(Ordinal);
  if Ordinal = TDBXColumnsIndex.DbxDataType then
  begin
    IsUnsigned := GetBoolean(TDBXColumnsIndex.IsUnsigned);
    if IsUnsigned then
      case Value of
        TDBXDataTypesEx.Int8Type:
          Value := TDBXDataTypesEx.UInt8Type;
        TDBXDataTypes.Int16Type:
          Value := TDBXDataTypes.UInt16Type;
        TDBXDataTypes.Int32Type:
          Value := TDBXDataTypes.UInt32Type;
        TDBXDataTypes.Int64Type:
          Value := TDBXDataTypes.UInt64Type;
      end;
  end;
  Result := Value;
end;

function TDBXMySqlCustomMetaDataReader.TDBXMySqlColumnsTableCursor.GetBoolean(Ordinal: Integer): Boolean;
begin
  CheckColumn(Ordinal, TDBXDataTypes.BooleanType);
  case Ordinal of
    TDBXColumnsIndex.IsUnicode:
      if FVersion5 then
        Result := (FOriginal.GetString(MysqlIsUnicode, '') = Utf8)
      else 
        Result := False;
    TDBXColumnsIndex.IsUnsigned:
      if FVersion5 then
        Result := FOriginal.GetAsBoolean(MysqlIsUnsigned)
      else 
        Result := FOriginal.GetBoolean(Ordinal);
    else
      Result := inherited GetBoolean(Ordinal);
  end;
end;

constructor TDBXMySqlCustomMetaDataReader.TDBXMySql4ColumnsCursor.Create(const Reader: TDBXMySqlCustomMetaDataReader; const Columns: TDBXColumnDescriptorArray; const Sql: WideString; const TableName: WideString);
begin
  inherited Create(Reader.FContext, TDBXMetaDataCollectionIndex.Columns, TDBXMetaDataCollectionName.Columns, Columns, nil);
  self.FReader := Reader;
  self.FSql := Sql;
  self.FTableName := TableName;
  if StringIsNil(TableName) then
  begin
    self.FTables := Reader.Tables;
    self.FTableIndex := -1;
  end;
  self.FColumnType := TDBXMySqlCustomMetaDataReader.TDBXMySqlColumnType.Create;
  InitNextCursor;
end;

destructor TDBXMySqlCustomMetaDataReader.TDBXMySql4ColumnsCursor.Destroy;
begin
  Close;
  inherited Destroy;
end;

function TDBXMySqlCustomMetaDataReader.TDBXMySql4ColumnsCursor.FindStringSize(const Ordinal: Integer; const SourceColumns: TDBXColumnDescriptorArray): Integer;
begin
  case Ordinal of
    TDBXColumnsIndex.ColumnName:
      Result := SourceColumns[ShowColumnsFieldOrdinal].DataSize;
    TDBXColumnsIndex.DefaultValue:
      Result := SourceColumns[ShowColumnsDefaultOrdinal].DataSize;
    else
      Result := DefaultVarcharPrecision;
  end;
end;

function TDBXMySqlCustomMetaDataReader.TDBXMySql4ColumnsCursor.Next: Boolean;
begin
  if FCursor = nil then
  begin
    Result := False;
    exit;
  end;
  while not FCursor.Next do
  begin
    FCursor.Close;
    FCursor.Free;
    FCursor := nil;
    if (FTables = nil) or not InitNextCursor then
    begin
      Result := False;
      exit;
    end;
  end;
  IncrAfter(FColumnNumber);
  FReader.ParseType(FCursor.GetAsString(ShowColumnsTypeOrdinal), FColumnType);
  Result := True;
end;

function TDBXMySqlCustomMetaDataReader.TDBXMySql4ColumnsCursor.InitNextCursor: Boolean;
var
  Query: WideString;
begin
  if FTables <> nil then
  begin
    IncrAfter(FTableIndex);
    if FTableIndex >= FTables.Count then
    begin
      Result := False;
      exit;
    end;
    FTableName := WideString(FTables[FTableIndex]);
  end;
  Query := FReader.ReplaceIdentifier(FSql, TDBXParameterName.TableName, FTableName, True);
  try
    FCursor := FReader.FContext.ExecuteQuery(Query, nil, nil);
  except
    on Ex: Exception do
    begin
      Ex := Ex;
      FCursor := nil;
    end;
  end;
  FColumnNumber := 0;
  Result := (FCursor <> nil);
end;

procedure TDBXMySqlCustomMetaDataReader.TDBXMySql4ColumnsCursor.Close;
begin
  if FCursor <> nil then
    FCursor.Close;
  FreeAndNil(FCursor);
  FreeAndNil(FTables);
  FreeAndNil(FColumnType);
end;

function TDBXMySqlCustomMetaDataReader.TDBXMySql4ColumnsCursor.IsNull(Ordinal: Integer): Boolean;
begin
  CheckColumn(Ordinal, TDBXDataTypes.UnknownType);
  case Ordinal of
    TDBXColumnsIndex.CatalogName,
    TDBXColumnsIndex.SchemaName:
      Result := True;
    else
      Result := False;
  end;
end;

function TDBXMySqlCustomMetaDataReader.TDBXMySql4ColumnsCursor.GetString(Ordinal: Integer): WideString;
begin
  CheckColumn(Ordinal, TDBXDataTypes.WideStringType);
  case Ordinal of
    TDBXColumnsIndex.TableName:
      Result := FTableName;
    TDBXColumnsIndex.ColumnName:
      Result := FCursor.GetAsString(ShowColumnsFieldOrdinal);
    TDBXColumnsIndex.DefaultValue:
      Result := ComputeDefaultValue;
    TDBXColumnsIndex.TypeName:
      Result := FColumnType.FDataType;
    else
      Result := NullString;
  end;
end;

function TDBXMySqlCustomMetaDataReader.TDBXMySql4ColumnsCursor.GetInt32(Ordinal: Integer): Integer;
begin
  CheckColumn(Ordinal, TDBXDataTypes.Int32Type);
  case Ordinal of
    TDBXColumnsIndex.Ordinal:
      Result := FColumnNumber;
    TDBXColumnsIndex.Precision:
      Result := FColumnType.FPrecision;
    TDBXColumnsIndex.Scale:
      Result := FColumnType.FScale;
    else
      Result := 0;
  end;
end;

function TDBXMySqlCustomMetaDataReader.TDBXMySql4ColumnsCursor.GetBoolean(Ordinal: Integer): Boolean;
begin
  CheckColumn(Ordinal, TDBXDataTypes.BooleanType);
  case Ordinal of
    TDBXColumnsIndex.IsAutoIncrement:
      Result := ComputeAutoIncrement;
    TDBXColumnsIndex.IsNullable:
      Result := ComputeNullable;
    TDBXColumnsIndex.IsUnsigned:
      Result := FColumnType.FUnsigned;
    TDBXColumnsIndex.IsUnicode:
      Result := False;
    else
      Result := False;
  end;
end;

function TDBXMySqlCustomMetaDataReader.TDBXMySql4ColumnsCursor.ComputeDefaultValue: WideString;
var
  DefaultValue: WideString;
  DataType: Integer;
begin
  DefaultValue := NullString;
  if not FCursor.IsNull(ShowColumnsDefaultOrdinal) then
    DefaultValue := FCursor.GetAsString(ShowColumnsDefaultOrdinal);
  if (not StringIsNil(DefaultValue)) and not (DefaultValue = CurrentTimestamp) then
  begin
    if Length(DefaultValue) = 0 then
      DefaultValue := NullString
    else 
    begin
      DataType := FReader.FindDataType(FColumnType.FDataType);
      case DataType of
        TDBXDataTypes.Int32Type:
          if (FColumnType.FDataType = FYear) then
            DefaultValue := Quote + DefaultValue + Quote;
        TDBXDataTypes.WideStringType,
        TDBXDataTypes.AnsiStringType,
        TDBXDataTypes.TimestampType,
        TDBXDataTypes.TimeType,
        TDBXDataTypes.DateType:
          DefaultValue := Quote + DefaultValue + Quote;
      end;
    end;
  end;
  Result := DefaultValue;
end;

function TDBXMySqlCustomMetaDataReader.TDBXMySql4ColumnsCursor.ComputeAutoIncrement: Boolean;
begin
  Result := not FCursor.IsNull(ShowColumnsExtraOrdinal) and (StringIndexOf(FCursor.GetAsString(ShowColumnsExtraOrdinal),FAuto_increment) >= 0);
end;

function TDBXMySqlCustomMetaDataReader.TDBXMySql4ColumnsCursor.ComputeNullable: Boolean;
begin
  Result := not FCursor.IsNull(ShowColumnsNullOrdinal) and (YForYes = FCursor.GetAsString(ShowColumnsNullOrdinal));
end;

constructor TDBXMySqlCustomMetaDataReader.TDBXMySql4IndexesCursor.Create(const Reader: TDBXMySqlCustomMetaDataReader; const Columns: TDBXColumnDescriptorArray; const Sql: WideString; const TableName: WideString);
begin
  inherited Create(Reader.FContext, TDBXMetaDataCollectionIndex.Indexes, TDBXMetaDataCollectionName.Indexes, Columns, nil);
  self.FReader := Reader;
  self.FSql := Sql;
  self.FTableName := TableName;
  if StringIsNil(TableName) then
  begin
    self.FTables := Reader.Tables;
    self.FTableIndex := -1;
  end;
  InitNextCursor;
end;

destructor TDBXMySqlCustomMetaDataReader.TDBXMySql4IndexesCursor.Destroy;
begin
  Close;
  inherited Destroy;
end;

function TDBXMySqlCustomMetaDataReader.TDBXMySql4IndexesCursor.FindStringSize(const Ordinal: Integer; const SourceColumns: TDBXColumnDescriptorArray): Integer;
begin
  case Ordinal of
    TDBXIndexesIndex.IndexName,
    TDBXIndexesIndex.ConstraintName:
      Result := SourceColumns[ShowIndexKeyNameOrdinal].DataSize;
    else
      Result := DefaultVarcharPrecision;
  end;
end;

function TDBXMySqlCustomMetaDataReader.TDBXMySql4IndexesCursor.Next: Boolean;
begin
  if FCursor = nil then
  begin
    Result := False;
    exit;
  end;
  FPrevTableName := FTableName;
  FPrevIndexName := FIndexName;
  repeat
    while not FCursor.Next do
    begin
      FCursor.Close;
      FCursor.Free;
      FCursor := nil;
      if (FTables = nil) or not InitNextCursor then
      begin
        Result := False;
        exit;
      end;
    end;
    FUniqueIndex := not FCursor.IsNull(ShowIndexNonUniqueOrdinal) and not FCursor.GetAsBoolean(ShowIndexNonUniqueOrdinal);
    FIndexName := FCursor.GetAsString(ShowIndexKeyNameOrdinal);
  until not ((FTableName = FPrevTableName) and (FIndexName = FPrevIndexName));
  Result := True;
end;

function TDBXMySqlCustomMetaDataReader.TDBXMySql4IndexesCursor.InitNextCursor: Boolean;
var
  Query: WideString;
begin
  if FTables <> nil then
  begin
    IncrAfter(FTableIndex);
    if FTableIndex >= FTables.Count then
    begin
      Result := False;
      exit;
    end;
    FTableName := WideString(FTables[FTableIndex]);
  end;
  Query := FReader.ReplaceIdentifier(FSql, TDBXParameterName.TableName, FTableName, True);
  try
    FCursor := FReader.FContext.ExecuteQuery(Query, nil, nil);
  except
    on Ex: Exception do
      FCursor := nil;
  end;
  Result := (FCursor <> nil);
end;

procedure TDBXMySqlCustomMetaDataReader.TDBXMySql4IndexesCursor.Close;
begin
  if FCursor <> nil then
    FCursor.Close;
  FreeAndNil(FCursor);
  FreeAndNil(FTables);
end;

function TDBXMySqlCustomMetaDataReader.TDBXMySql4IndexesCursor.IsNull(Ordinal: Integer): Boolean;
begin
  CheckColumn(Ordinal, TDBXDataTypes.UnknownType);
  case Ordinal of
    TDBXIndexesIndex.CatalogName,
    TDBXIndexesIndex.SchemaName:
      Result := True;
    TDBXIndexesIndex.ConstraintName:
      Result := not FUniqueIndex;
    else
      Result := False;
  end;
end;

function TDBXMySqlCustomMetaDataReader.TDBXMySql4IndexesCursor.GetString(Ordinal: Integer): WideString;
begin
  CheckColumn(Ordinal, TDBXDataTypes.WideStringType);
  case Ordinal of
    TDBXIndexesIndex.TableName:
      Result := FTableName;
    TDBXIndexesIndex.IndexName:
      Result := FIndexName;
    TDBXIndexesIndex.ConstraintName:
      Result := ComputeConstraintName;
    else
      Result := NullString;
  end;
end;

function TDBXMySqlCustomMetaDataReader.TDBXMySql4IndexesCursor.GetBoolean(Ordinal: Integer): Boolean;
begin
  CheckColumn(Ordinal, TDBXDataTypes.BooleanType);
  case Ordinal of
    TDBXIndexesIndex.IsPrimary:
      Result := FUniqueIndex and (Primary = FIndexName);
    TDBXIndexesIndex.IsUnique:
      Result := FUniqueIndex;
    TDBXIndexesIndex.IsAscending:
      Result := True;
    else
      Result := False;
  end;
end;

function TDBXMySqlCustomMetaDataReader.TDBXMySql4IndexesCursor.ComputeConstraintName: WideString;
var
  ConstraintName: WideString;
begin
  ConstraintName := NullString;
  if FUniqueIndex then
    ConstraintName := FIndexName;
  Result := ConstraintName;
end;

constructor TDBXMySqlCustomMetaDataReader.TDBXMySql4IndexColumnsCursor.Create(const Reader: TDBXMySqlCustomMetaDataReader; const Columns: TDBXColumnDescriptorArray; const Sql: WideString; const TableName: WideString; const IndexName: WideString);
begin
  inherited Create(Reader.FContext, TDBXMetaDataCollectionIndex.IndexColumns, TDBXMetaDataCollectionName.IndexColumns, Columns, nil);
  self.FReader := Reader;
  self.FSql := Sql;
  self.FTableName := TableName;
  self.FWantedIndexName := IndexName;
  if StringIsNil(TableName) then
  begin
    self.FTables := Reader.Tables;
    self.FTableIndex := -1;
  end;
  InitNextCursor;
end;

destructor TDBXMySqlCustomMetaDataReader.TDBXMySql4IndexColumnsCursor.Destroy;
begin
  Close;
  inherited Destroy;
end;

function TDBXMySqlCustomMetaDataReader.TDBXMySql4IndexColumnsCursor.FindStringSize(const Ordinal: Integer; const SourceColumns: TDBXColumnDescriptorArray): Integer;
begin
  case Ordinal of
    TDBXIndexColumnsIndex.IndexName:
      Result := SourceColumns[ShowIndexKeyNameOrdinal].DataSize;
    TDBXIndexColumnsIndex.ColumnName:
      Result := SourceColumns[ShowIndexColumnNameOrdinal].DataSize;
    else
      Result := DefaultVarcharPrecision;
  end;
end;

function TDBXMySqlCustomMetaDataReader.TDBXMySql4IndexColumnsCursor.Next: Boolean;
begin
  if FCursor = nil then
  begin
    Result := False;
    exit;
  end;
  repeat
    while not FCursor.Next do
    begin
      FCursor.Close;
      FCursor.Free;
      FCursor := nil;
      if (FTables = nil) or not InitNextCursor then
      begin
        Result := False;
        exit;
      end;
    end;
    FIndexName := FCursor.GetAsString(ShowIndexKeyNameOrdinal);
  until ((StringIsNil(FWantedIndexName)) or (FWantedIndexName = FIndexName));
  Result := True;
end;

function TDBXMySqlCustomMetaDataReader.TDBXMySql4IndexColumnsCursor.InitNextCursor: Boolean;
var
  Query: WideString;
begin
  if FTables <> nil then
  begin
    IncrAfter(FTableIndex);
    if FTableIndex >= FTables.Count then
    begin
      Result := False;
      exit;
    end;
    FTableName := WideString(FTables[FTableIndex]);
  end;
  Query := FReader.ReplaceIdentifier(FSql, TDBXParameterName.TableName, FTableName, True);
  try
    FCursor := FReader.FContext.ExecuteQuery(Query, nil, nil);
  except
    on Ex: Exception do
      FCursor := nil;
  end;
  Result := (FCursor <> nil);
end;

procedure TDBXMySqlCustomMetaDataReader.TDBXMySql4IndexColumnsCursor.Close;
begin
  if FCursor <> nil then
    FCursor.Close;
  FreeAndNil(FCursor);
  FreeAndNil(FTables);
end;

function TDBXMySqlCustomMetaDataReader.TDBXMySql4IndexColumnsCursor.IsNull(Ordinal: Integer): Boolean;
begin
  CheckColumn(Ordinal, TDBXDataTypes.UnknownType);
  case Ordinal of
    TDBXIndexColumnsIndex.CatalogName,
    TDBXIndexColumnsIndex.SchemaName:
      Result := True;
    else
      Result := False;
  end;
end;

function TDBXMySqlCustomMetaDataReader.TDBXMySql4IndexColumnsCursor.GetString(Ordinal: Integer): WideString;
begin
  CheckColumn(Ordinal, TDBXDataTypes.WideStringType);
  case Ordinal of
    TDBXIndexColumnsIndex.TableName:
      Result := FTableName;
    TDBXIndexColumnsIndex.IndexName:
      Result := FIndexName;
    TDBXIndexColumnsIndex.ColumnName:
      Result := FCursor.GetAsString(ShowIndexColumnNameOrdinal);
    else
      Result := NullString;
  end;
end;

function TDBXMySqlCustomMetaDataReader.TDBXMySql4IndexColumnsCursor.GetInt32(Ordinal: Integer): Integer;
begin
  CheckColumn(Ordinal, TDBXDataTypes.Int32Type);
  case Ordinal of
    TDBXIndexColumnsIndex.Ordinal:
      Result := FCursor.GetAsInt32(ShowIndexSeqInIndexOrdinal);
    else
      Result := 0;
  end;
end;

function TDBXMySqlCustomMetaDataReader.TDBXMySql4IndexColumnsCursor.GetBoolean(Ordinal: Integer): Boolean;
begin
  CheckColumn(Ordinal, TDBXDataTypes.BooleanType);
  case Ordinal of
    TDBXIndexColumnsIndex.IsAscending:
      Result := True;
    else
      Result := False;
  end;
end;

constructor TDBXMySqlCustomMetaDataReader.TDBXMySql4ForeignKeyCursor.Create(const Reader: TDBXMySqlCustomMetaDataReader; const Columns: TDBXColumnDescriptorArray; const Sql: WideString; const TableName: WideString);
begin
  self.FKey := TDBXMySqlCustomMetaDataReader.TDBXMySqlForeignKey.Create;
  inherited Create(Reader.FContext, TDBXMetaDataCollectionIndex.ForeignKeys, TDBXMetaDataCollectionName.ForeignKeys, Columns, nil);
  self.FReader := Reader;
  self.FSql := Sql;
  self.FTableName := TableName;
  if StringIsNil(TableName) then
  begin
    self.FTables := Reader.Tables;
    self.FTableIndex := -1;
  end;
  InitNextCursor;
end;

destructor TDBXMySqlCustomMetaDataReader.TDBXMySql4ForeignKeyCursor.Destroy;
begin
  Close;
  inherited Destroy;
end;

function TDBXMySqlCustomMetaDataReader.TDBXMySql4ForeignKeyCursor.FindStringSize(const Ordinal: Integer; const SourceColumns: TDBXColumnDescriptorArray): Integer;
begin
  Result := DefaultVarcharPrecision;
end;

function TDBXMySqlCustomMetaDataReader.TDBXMySql4ForeignKeyCursor.Next: Boolean;
begin
  if FCursor = nil then
  begin
    Result := False;
    exit;
  end;
  repeat
    if FParseIndex < 0 then
    begin
      while not FCursor.Next do
      begin
        FCursor.Close;
        FCursor.Free;
        FCursor := nil;
        if (FTables = nil) or not InitNextCursor then
        begin
          Result := False;
          exit;
        end;
      end;
      FSqlCreateTable := FCursor.GetAsString(ShowCreateTableSqlOrdinal);
      FParseIndex := 0;
    end;
    FParseIndex := FReader.ParseCreateTableForNextForeignKey(FSqlCreateTable, FParseIndex, FKey);
  until FParseIndex >= 0;
  Result := True;
end;

function TDBXMySqlCustomMetaDataReader.TDBXMySql4ForeignKeyCursor.InitNextCursor: Boolean;
var
  Query: WideString;
begin
  if FTables <> nil then
  begin
    IncrAfter(FTableIndex);
    if FTableIndex >= FTables.Count then
    begin
      Result := False;
      exit;
    end;
    FTableName := WideString(FTables[FTableIndex]);
  end;
  Query := FReader.ReplaceIdentifier(FSql, TDBXParameterName.TableName, FTableName, True);
  try
    FCursor := FReader.FContext.ExecuteQuery(Query, nil, nil);
  except
    on Ex: Exception do
      FCursor := nil;
  end;
  FParseIndex := -1;
  Result := (FCursor <> nil);
end;

procedure TDBXMySqlCustomMetaDataReader.TDBXMySql4ForeignKeyCursor.Close;
begin
  if FCursor <> nil then
    FCursor.Close;
  FreeAndNil(FCursor);
  FreeAndNil(FTables);
  FreeAndNil(FKey);
end;

function TDBXMySqlCustomMetaDataReader.TDBXMySql4ForeignKeyCursor.IsNull(Ordinal: Integer): Boolean;
begin
  CheckColumn(Ordinal, TDBXDataTypes.UnknownType);
  case Ordinal of
    TDBXForeignKeysIndex.CatalogName,
    TDBXForeignKeysIndex.SchemaName:
      Result := True;
    else
      Result := False;
  end;
end;

function TDBXMySqlCustomMetaDataReader.TDBXMySql4ForeignKeyCursor.GetString(Ordinal: Integer): WideString;
begin
  CheckColumn(Ordinal, TDBXDataTypes.WideStringType);
  case Ordinal of
    TDBXForeignKeysIndex.TableName:
      Result := FTableName;
    TDBXForeignKeysIndex.ForeignKeyName:
      Result := FKey.FConstraintName;
    else
      Result := NullString;
  end;
end;

constructor TDBXMySqlCustomMetaDataReader.TDBXMySql4ForeignKeyColumnsCursor.Create(const Reader: TDBXMySqlCustomMetaDataReader; const Columns: TDBXColumnDescriptorArray; const Sql: WideString; const TableName: WideString; const ForeignKeyName: WideString; const PrimaryTableName: WideString; const PrimaryKeyName: WideString);
begin
  self.FKey := TDBXMySqlCustomMetaDataReader.TDBXMySqlForeignKey.Create;
  inherited Create(Reader.FContext, TDBXMetaDataCollectionIndex.ForeignKeyColumns, TDBXMetaDataCollectionName.ForeignKeyColumns, Columns, nil);
  self.FReader := Reader;
  self.FSql := Sql;
  self.FTableName := TableName;
  self.FForeignKeyName := ForeignKeyName;
  self.FPrimaryTableName := PrimaryTableName;
  self.FPrimaryKeyName := PrimaryKeyName;
  if StringIsNil(TableName) then
  begin
    self.FTables := Reader.Tables;
    self.FTableIndex := -1;
  end;
  InitNextCursor;
end;

destructor TDBXMySqlCustomMetaDataReader.TDBXMySql4ForeignKeyColumnsCursor.Destroy;
begin
  Close;
  inherited Destroy;
end;

function TDBXMySqlCustomMetaDataReader.TDBXMySql4ForeignKeyColumnsCursor.FindStringSize(const Ordinal: Integer; const SourceColumns: TDBXColumnDescriptorArray): Integer;
begin
  Result := DefaultVarcharPrecision;
end;

function TDBXMySqlCustomMetaDataReader.TDBXMySql4ForeignKeyColumnsCursor.Next: Boolean;
begin
  if FCursor = nil then
  begin
    Result := False;
    exit;
  end;
  IncrAfter(FKeyIndex);
  if FKeyIndex < FKey.FKeyColumns.Count then
  begin
    Result := True;
    exit;
  end;
  repeat
    if FParseIndex < 0 then
    begin
      while not FCursor.Next do
      begin
        FCursor.Close;
        FCursor.Free;
        FCursor := nil;
        if (FTables = nil) or not InitNextCursor then
        begin
          Result := False;
          exit;
        end;
      end;
      FSqlCreateTable := FCursor.GetAsString(ShowCreateTableSqlOrdinal);
      FParseIndex := 0;
    end;
    FParseIndex := FReader.ParseCreateTableForNextForeignKey(FSqlCreateTable, FParseIndex, FKey);
  until ((FParseIndex >= 0) and (FKey.FKeyColumns.Count > 0) and ((StringIsNil(FForeignKeyName)) or (FForeignKeyName = FKey.FConstraintName)) and ((StringIsNil(FPrimaryTableName)) or (FPrimaryTableName = FKey.FReferencedTableName)));
  FKeyIndex := 0;
  Result := True;
end;

function TDBXMySqlCustomMetaDataReader.TDBXMySql4ForeignKeyColumnsCursor.InitNextCursor: Boolean;
var
  Query: WideString;
begin
  if FTables <> nil then
  begin
    IncrAfter(FTableIndex);
    if FTableIndex >= FTables.Count then
    begin
      Result := False;
      exit;
    end;
    FTableName := WideString(FTables[FTableIndex]);
  end;
  Query := FReader.ReplaceIdentifier(FSql, TDBXParameterName.TableName, FTableName, True);
  try
    FCursor := FReader.FContext.ExecuteQuery(Query, nil, nil);
  except
    on Ex: Exception do
      FCursor := nil;
  end;
  FParseIndex := -1;
  Result := (FCursor <> nil);
end;

procedure TDBXMySqlCustomMetaDataReader.TDBXMySql4ForeignKeyColumnsCursor.Close;
begin
  if FCursor <> nil then
    FCursor.Close;
  FreeAndNil(FCursor);
  FreeAndNil(FTables);
  FreeAndNil(FKey);
end;

function TDBXMySqlCustomMetaDataReader.TDBXMySql4ForeignKeyColumnsCursor.IsNull(Ordinal: Integer): Boolean;
begin
  CheckColumn(Ordinal, TDBXDataTypes.UnknownType);
  case Ordinal of
    TDBXForeignKeyColumnsIndex.CatalogName,
    TDBXForeignKeyColumnsIndex.SchemaName,
    TDBXForeignKeyColumnsIndex.PrimaryCatalogName,
    TDBXForeignKeyColumnsIndex.PrimarySchemaName,
    TDBXForeignKeyColumnsIndex.PrimaryKeyName:
      Result := True;
    else
      Result := False;
  end;
end;

function TDBXMySqlCustomMetaDataReader.TDBXMySql4ForeignKeyColumnsCursor.GetString(Ordinal: Integer): WideString;
begin
  CheckColumn(Ordinal, TDBXDataTypes.WideStringType);
  case Ordinal of
    TDBXForeignKeyColumnsIndex.TableName:
      Result := FTableName;
    TDBXForeignKeyColumnsIndex.ForeignKeyName:
      Result := FKey.FConstraintName;
    TDBXForeignKeyColumnsIndex.PrimaryTableName:
      Result := FKey.FReferencedTableName;
    TDBXForeignKeyColumnsIndex.ColumnName:
      Result := WideString(FKey.FKeyColumns[FKeyIndex]);
    TDBXForeignKeyColumnsIndex.PrimaryColumnName:
      Result := WideString(FKey.FReferencedColumns[FKeyIndex]);
    else
      Result := NullString;
  end;
end;

function TDBXMySqlCustomMetaDataReader.TDBXMySql4ForeignKeyColumnsCursor.GetInt32(Ordinal: Integer): Integer;
begin
  CheckColumn(Ordinal, TDBXDataTypes.Int32Type);
  case Ordinal of
    TDBXForeignKeyColumnsIndex.Ordinal:
      Result := FKeyIndex + 1;
    else
      Result := 0;
  end;
end;

constructor TDBXMySqlCustomMetaDataReader.TDBXMySqlProcedureSourcesCursor.Create(const Reader: TDBXMySqlCustomMetaDataReader; const Columns: TDBXColumnDescriptorArray; const Sql: WideString; const SchemaName: WideString; const ProcedureName: WideString);
begin
  inherited Create(Reader.FContext, TDBXMetaDataCollectionIndex.ProcedureSources, TDBXMetaDataCollectionName.ProcedureSources, Columns, nil);
  self.FReader := Reader;
  self.FSql := Sql;
  self.FProcedureName := ProcedureName;
  self.FProcedureType := &Procedure;
  self.FProcedures := TDBXStringList.Create;
  self.FProcedureTypes := TDBXStringList.Create;
  self.FReader.GetProcedures(SchemaName, ProcedureName, FProcedures, FProcedureTypes);
  self.FProcedureIndex := -1;
  InitNextCursor;
end;

destructor TDBXMySqlCustomMetaDataReader.TDBXMySqlProcedureSourcesCursor.Destroy;
begin
  Close;
  inherited Destroy;
end;

function TDBXMySqlCustomMetaDataReader.TDBXMySqlProcedureSourcesCursor.FindStringSize(const Ordinal: Integer; const SourceColumns: TDBXColumnDescriptorArray): Integer;
begin
  Result := DefaultVarcharPrecision;
end;

function TDBXMySqlCustomMetaDataReader.TDBXMySqlProcedureSourcesCursor.Next: Boolean;
begin
  if FCursor = nil then
  begin
    Result := False;
    exit;
  end;
  while not FCursor.Next do
  begin
    FCursor.Close;
    FCursor.Free;
    FCursor := nil;
    if not InitNextCursor then
    begin
      Result := False;
      exit;
    end;
  end;
  FDefiner := ComputeDefiner;
  Result := True;
end;

function TDBXMySqlCustomMetaDataReader.TDBXMySqlProcedureSourcesCursor.InitNextCursor: Boolean;
var
  Query: WideString;
begin
  IncrAfter(FProcedureIndex);
  if FProcedureIndex >= FProcedures.Count then
  begin
    Result := False;
    exit;
  end;
  FProcedureName := WideString(FProcedures[FProcedureIndex]);
  FProcedureType := WideString(FProcedureTypes[FProcedureIndex]);
  Query := FSql;
  Query := FReader.ReplaceIdentifier(Query, TDBXParameterName.ProcedureName, FProcedureName, True);
  Query := FReader.ReplaceIdentifier(Query, TDBXParameterName.ProcedureType, FProcedureType, False);
  FCursor := FReader.FContext.ExecuteQuery(Query, nil, nil);
  Result := True;
end;

procedure TDBXMySqlCustomMetaDataReader.TDBXMySqlProcedureSourcesCursor.Close;
begin
  if FCursor <> nil then
    FCursor.Close;
  FCursor.Free;
  FCursor := nil;
  FreeAndNil(FProcedures);
  FreeAndNil(FProcedureTypes);
end;

function TDBXMySqlCustomMetaDataReader.TDBXMySqlProcedureSourcesCursor.IsNull(Ordinal: Integer): Boolean;
begin
  CheckColumn(Ordinal, TDBXDataTypes.UnknownType);
  case Ordinal of
    TDBXProcedureSourcesIndex.CatalogName,
    TDBXProcedureSourcesIndex.ExternalDefinition:
      Result := True;
    TDBXProcedureSourcesIndex.SchemaName:
      Result := (StringIsNil(FDefiner));
    else
      Result := False;
  end;
end;

function TDBXMySqlCustomMetaDataReader.TDBXMySqlProcedureSourcesCursor.GetString(Ordinal: Integer): WideString;
begin
  CheckColumn(Ordinal, TDBXDataTypes.WideStringType);
  case Ordinal of
    TDBXProcedureSourcesIndex.SchemaName:
      Result := FDefiner;
    TDBXProcedureSourcesIndex.ProcedureName:
      Result := FProcedureName;
    TDBXProcedureSourcesIndex.ProcedureType:
      Result := FProcedureType;
    TDBXProcedureSourcesIndex.Definition:
      Result := ComputeDefinition;
    else
      Result := NullString;
  end;
end;

function TDBXMySqlCustomMetaDataReader.TDBXMySqlProcedureSourcesCursor.ComputeDefinition: WideString;
var
  SqlCreateProcedure: WideString;
  Index: Integer;
begin
  SqlCreateProcedure := FCursor.GetAsString(ShowCreateProcedureSqlOrdinal);
  Index := StringIndexOf(SqlCreateProcedure,FProcedureType);
  if Index >= 0 then
    SqlCreateProcedure := &Create + '"' + Copy(SqlCreateProcedure,Index+1,Length(SqlCreateProcedure)-(Index));
  Result := SqlCreateProcedure;
end;

function TDBXMySqlCustomMetaDataReader.TDBXMySqlProcedureSourcesCursor.ComputeDefiner: WideString;
var
  Definer: WideString;
  SqlCreateProcedure: WideString;
  Index: Integer;
  EndIndex: Integer;
begin
  Definer := NullString;
  SqlCreateProcedure := FCursor.GetAsString(ShowCreateProcedureSqlOrdinal);
  Index := StringIndexOf(SqlCreateProcedure,DefinerString);
  if Index >= 0 then
  begin
    Index := Index + Length(DefinerString) + 1;
    EndIndex := StringIndexOf(SqlCreateProcedure,FReader.SqlIdentifierQuoteSuffix,Index);
    if EndIndex > 0 then
      Definer := Copy(SqlCreateProcedure,Index+1,EndIndex-(Index));
  end;
  Result := Definer;
end;

constructor TDBXMySqlCustomMetaDataReader.TDBXMySqlProcedureParametersCursor.Create(const Reader: TDBXMySqlCustomMetaDataReader; const Columns: TDBXColumnDescriptorArray; const Sql: WideString; const SchemaName: WideString; const ProcedureName: WideString; const ParameterName: WideString);
begin
  inherited Create(Reader.FContext, TDBXMetaDataCollectionIndex.ProcedureParameters, TDBXMetaDataCollectionName.ProcedureParameters, Columns, nil);
  self.FReader := Reader;
  self.FSql := Sql;
  self.FProcedureName := ProcedureName;
  self.FParameterName := ParameterName;
  self.FProcedureType := &Procedure;
  self.FProcedures := TDBXStringList.Create;
  self.FProcedureTypes := TDBXStringList.Create;
  self.FReader.GetProcedures(SchemaName, ProcedureName, FProcedures, FProcedureTypes);
  self.FProcedureIndex := -1;
  self.FParams := TDBXArrayList.Create;
  InitNextCursor;
end;

destructor TDBXMySqlCustomMetaDataReader.TDBXMySqlProcedureParametersCursor.Destroy;
begin
  Close;
  if FParams <> nil then
    FParams.Clear;
  FreeAndNil(FParams);
  inherited Destroy;
end;

function TDBXMySqlCustomMetaDataReader.TDBXMySqlProcedureParametersCursor.FindStringSize(const Ordinal: Integer; const SourceColumns: TDBXColumnDescriptorArray): Integer;
begin
  Result := DefaultVarcharPrecision;
end;

function TDBXMySqlCustomMetaDataReader.TDBXMySqlProcedureParametersCursor.Next: Boolean;
begin
  if FCursor = nil then
  begin
    Result := False;
    exit;
  end;
  IncrAfter(FParameterIndex);
  while True do
  begin
    while FParameterIndex < FParams.Count do
    begin
      FParameter := TDBXMySqlCustomMetaDataReader.TDBXMySqlParameter(FParams[FParameterIndex]);
      if (StringIsNil(FParameterName)) or (FParameterName = FParameter.FName) then
      begin
        Result := True;
        exit;
      end;
      IncrAfter(FParameterIndex);
    end;
    while not FCursor.Next do
    begin
      FCursor.Close;
      FreeAndNil(FCursor);
      if not InitNextCursor then
      begin
        Result := False;
        exit;
      end;
    end;
    ComputeParams;
  end;
end;

function TDBXMySqlCustomMetaDataReader.TDBXMySqlProcedureParametersCursor.InitNextCursor: Boolean;
var
  Query: WideString;
begin
  IncrAfter(FProcedureIndex);
  if FProcedureIndex >= FProcedures.Count then
  begin
    Result := False;
    exit;
  end;
  FProcedureName := WideString(FProcedures[FProcedureIndex]);
  FProcedureType := WideString(FProcedureTypes[FProcedureIndex]);
  Query := FSql;
  Query := FReader.ReplaceIdentifier(Query, TDBXParameterName.ProcedureName, FProcedureName, True);
  Query := FReader.ReplaceIdentifier(Query, TDBXParameterName.ProcedureType, FProcedureType, False);
  FCursor := FReader.FContext.ExecuteQuery(Query, nil, nil);
  Result := True;
end;

procedure TDBXMySqlCustomMetaDataReader.TDBXMySqlProcedureParametersCursor.Close;
begin
  if FCursor <> nil then
    FCursor.Close;
  FreeAndNil(FCursor);
  FreeAndNil(FProcedures);
  FreeAndNil(FProcedureTypes);
end;

function TDBXMySqlCustomMetaDataReader.TDBXMySqlProcedureParametersCursor.IsNull(Ordinal: Integer): Boolean;
begin
  CheckColumn(Ordinal, TDBXDataTypes.UnknownType);
  case Ordinal of
    TDBXProcedureParametersIndex.CatalogName:
      Result := (StringIsNil(FDefiner));
    TDBXProcedureParametersIndex.SchemaName,
    TDBXProcedureParametersIndex.DbxDataType,
    TDBXProcedureParametersIndex.IsFixedLength,
    TDBXProcedureParametersIndex.IsLong:
      Result := True;
    else
      Result := False;
  end;
end;

function TDBXMySqlCustomMetaDataReader.TDBXMySqlProcedureParametersCursor.GetString(Ordinal: Integer): WideString;
begin
  CheckColumn(Ordinal, TDBXDataTypes.WideStringType);
  case Ordinal of
    TDBXProcedureParametersIndex.CatalogName:
      Result := FDefiner;
    TDBXProcedureParametersIndex.ProcedureName:
      Result := FProcedureName;
    TDBXProcedureParametersIndex.ParameterName:
      Result := FParameter.FName;
    TDBXProcedureParametersIndex.ParameterMode:
      Result := FParameter.FMode;
    TDBXProcedureParametersIndex.TypeName:
      Result := FParameter.FDataType;
    else
      Result := NullString;
  end;
end;

function TDBXMySqlCustomMetaDataReader.TDBXMySqlProcedureParametersCursor.GetInt32(Ordinal: Integer): Integer;
begin
  CheckColumn(Ordinal, TDBXDataTypes.Int32Type);
  case Ordinal of
    TDBXProcedureParametersIndex.Precision:
      Result := FParameter.FPrecision;
    TDBXProcedureParametersIndex.Scale:
      Result := FParameter.FScale;
    TDBXProcedureParametersIndex.Ordinal:
      Result := FParameter.FOrdinal;
    else
      Result := 0;
  end;
end;

function TDBXMySqlCustomMetaDataReader.TDBXMySqlProcedureParametersCursor.GetBoolean(Ordinal: Integer): Boolean;
begin
  CheckColumn(Ordinal, TDBXDataTypes.BooleanType);
  case Ordinal of
    TDBXProcedureParametersIndex.IsNullable:
      Result := not FParameter.FNotnull;
    TDBXProcedureParametersIndex.IsUnicode:
      Result := FParameter.FUnicode;
    TDBXProcedureParametersIndex.IsUnsigned:
      Result := FParameter.FUnsigned;
    else
      Result := False;
  end;
end;

procedure TDBXMySqlCustomMetaDataReader.TDBXMySqlProcedureParametersCursor.ComputeParams;
var
  SqlCreateProcedure: WideString;
begin
  SqlCreateProcedure := FCursor.GetAsString(ShowCreateProcedureSqlOrdinal);
  FDefiner := FReader.ParseProcedureDefiner(SqlCreateProcedure);
  FReader.ParseProcedure(SqlCreateProcedure, FProcedureType, FParams);
  FParameterIndex := 0;
end;

function TDBXMySqlMetaDataReader.GetProductName: WideString;
begin
  Result := 'MySQL';
end;

function TDBXMySqlMetaDataReader.GetSqlIdentifierQuotePrefix: WideString;
begin
  Result := '`';
end;

function TDBXMySqlMetaDataReader.GetSqlIdentifierQuoteSuffix: WideString;
begin
  Result := '`';
end;

function TDBXMySqlMetaDataReader.GetSqlIdentifierQuoteChar: WideString;
begin
  Result := '`';
end;

function TDBXMySqlMetaDataReader.GetTableType: WideString;
begin
  Result := 'BASE TABLE';
end;

function TDBXMySqlMetaDataReader.IsDescendingIndexColumnsSupported: Boolean;
begin
  Result := False;
end;

function TDBXMySqlMetaDataReader.IsLowerCaseIdentifiersSupported: Boolean;
begin
  Result := True;
end;

function TDBXMySqlMetaDataReader.IsUpperCaseIdentifiersSupported: Boolean;
begin
  Result := False;
end;

function TDBXMySqlMetaDataReader.IsMultipleCommandsSupported: Boolean;
begin
  Result := False;
end;

function TDBXMySqlMetaDataReader.FetchCatalogs: TDBXTableStorage;
var
  Columns: TDBXColumnDescriptorArray;
begin
  Columns := TDBXMetaDataCollectionColumns.CreateCatalogsColumns;
  Result := TDBXBaseMetaDataReader.TDBXEmptyTableCursor.Create(TDBXMetaDataCollectionIndex.Catalogs, TDBXMetaDataCollectionName.Catalogs, Columns);
end;

function TDBXMySqlMetaDataReader.FetchSchemas(const CatalogName: WideString): TDBXTableStorage;
var
  Columns: TDBXColumnDescriptorArray;
begin
  Columns := TDBXMetaDataCollectionColumns.CreateSchemasColumns;
  Result := TDBXBaseMetaDataReader.TDBXEmptyTableCursor.Create(TDBXMetaDataCollectionIndex.Schemas, TDBXMetaDataCollectionName.Schemas, Columns);
end;

function TDBXMySqlMetaDataReader.GetSqlForTables: WideString;
var
  CurrentVersion: WideString;
begin
  CurrentVersion := Version;
  if CurrentVersion >= '05.00.0000' then
    Result := 'SELECT TABLE_SCHEMA, NULL, TABLE_NAME, CASE TABLE_TYPE WHEN ''BASE TABLE'' THEN ''TABLE'' ELSE TABLE_TYPE END ' +
              'FROM INFORMATION_SCHEMA.TABLES ' +
              'WHERE (TABLE_SCHEMA = :CATALOG_NAME OR (:CATALOG_NAME IS NULL)) AND (1=1 OR :SCHEMA_NAME IS NULL) AND (TABLE_NAME = :TABLE_NAME OR (:TABLE_NAME IS NULL)) AND (TABLE_TYPE IN (:TABLES,:VIEWS,:SYSTEM_VIEWS,:SYSTEM_TABLES)) ' +
              'ORDER BY 1,2,3'
  else 
    Result := 'SHOW TABLES';
end;

function TDBXMySqlMetaDataReader.GetSqlForViews: WideString;
var
  CurrentVersion: WideString;
begin
  CurrentVersion := Version;
  if CurrentVersion >= '05.00.0000' then
    Result := 'SELECT TABLE_SCHEMA, NULL, TABLE_NAME, VIEW_DEFINITION ' +
              'FROM INFORMATION_SCHEMA.VIEWS ' +
              'WHERE (TABLE_SCHEMA = :CATALOG_NAME OR (:CATALOG_NAME IS NULL)) AND (1=1 OR :SCHEMA_NAME IS NULL) AND (TABLE_NAME = :VIEW_NAME OR (:VIEW_NAME IS NULL)) ' +
              'ORDER BY 1,2,3'
  else 
    Result := 'EmptyTable';
end;

function TDBXMySqlMetaDataReader.GetSqlForColumns: WideString;
var
  CurrentVersion: WideString;
begin
  CurrentVersion := Version;
  if CurrentVersion >= '05.00.0000' then
    Result := 'SELECT TABLE_SCHEMA, NULL, TABLE_NAME, COLUMN_NAME, DATA_TYPE, COALESCE(NUMERIC_PRECISION,CHARACTER_MAXIMUM_LENGTH), NUMERIC_SCALE, ORDINAL_POSITION, CAST(CASE WHEN COLUMN_DEFAULT IS NOT NULL AND COLUMN_DEFAULT <> ''CURRENT_TIMESTAMP'' AND DATA_TYPE IN (''ch' + 'ar'',''varchar'',''timestamp'',''datetime'',''date'',''time'',''year'') THEN CONCAT("''",COLUMN_DEFAULT,"''") ELSE COLUMN_DEFAULT END AS CHAR(255)), IS_NULLABLE=''YES'', LOCATE(''auto_increment'',EXTRA) > 0, -1, CHARACTER_SET_NAME, (LOCATE(''unsigned'',COLUMN_TYPE) > 0) ' +
              'FROM INFORMATION_SCHEMA.COLUMNS ' +
              'WHERE (TABLE_SCHEMA = :CATALOG_NAME OR (:CATALOG_NAME IS NULL)) AND (1=1 OR :SCHEMA_NAME IS NULL) AND (TABLE_NAME = :TABLE_NAME OR (:TABLE_NAME IS NULL)) ' +
              'ORDER BY 1,2,3,ORDINAL_POSITION'
  else 
    Result := 'SHOW COLUMNS FROM :TABLE_NAME';
end;

function TDBXMySqlMetaDataReader.FetchColumnConstraints(const CatalogName: WideString; const SchemaName: WideString; const TableName: WideString): TDBXTableStorage;
var
  Columns: TDBXColumnDescriptorArray;
begin
  Columns := TDBXMetaDataCollectionColumns.CreateColumnConstraintsColumns;
  Result := TDBXBaseMetaDataReader.TDBXEmptyTableCursor.Create(TDBXMetaDataCollectionIndex.ColumnConstraints, TDBXMetaDataCollectionName.ColumnConstraints, Columns);
end;

function TDBXMySqlMetaDataReader.GetSqlForIndexes: WideString;
var
  CurrentVersion: WideString;
begin
  CurrentVersion := Version;
  if CurrentVersion >= '05.00.0000' then
    Result := 'SELECT TABLE_SCHEMA, NULL, TABLE_NAME, INDEX_NAME, CASE WHEN NON_UNIQUE = 0 THEN INDEX_NAME ELSE NULL END, INDEX_NAME=''PRIMARY'', NON_UNIQUE=0, 1=1 ' +
              'FROM INFORMATION_SCHEMA.STATISTICS ' +
              'WHERE (TABLE_SCHEMA = :CATALOG_NAME OR (:CATALOG_NAME IS NULL)) AND (1=1 OR :SCHEMA_NAME IS NULL) AND (TABLE_NAME = :TABLE_NAME OR (:TABLE_NAME IS NULL)) ' +
              'GROUP BY 1, 2, 3 ,4 ' +
              'ORDER BY 1, 2, 3, 4'
  else 
    Result := 'SHOW INDEX FROM :TABLE_NAME';
end;

function TDBXMySqlMetaDataReader.GetSqlForIndexColumns: WideString;
var
  CurrentVersion: WideString;
begin
  CurrentVersion := Version;
  if CurrentVersion >= '05.00.0000' then
    Result := 'SELECT TABLE_SCHEMA, NULL, TABLE_NAME, INDEX_NAME, COLUMN_NAME, SEQ_IN_INDEX, COLLATION=''A'' ' +
              'FROM INFORMATION_SCHEMA.STATISTICS ' +
              'WHERE (TABLE_SCHEMA = :CATALOG_NAME OR (:CATALOG_NAME IS NULL)) AND (1=1 OR :SCHEMA_NAME IS NULL) AND (TABLE_NAME = :TABLE_NAME OR (:TABLE_NAME IS NULL)) AND (INDEX_NAME = :INDEX_NAME OR (:INDEX_NAME IS NULL)) ' +
              'ORDER BY 1, 2, 3, 4, SEQ_IN_INDEX'
  else 
    Result := 'SHOW INDEX FROM :TABLE_NAME';
end;

function TDBXMySqlMetaDataReader.GetSqlForForeignKeys: WideString;
var
  CurrentVersion: WideString;
begin
  CurrentVersion := Version;
  if CurrentVersion >= '05.00.0000' then
    Result := 'SELECT TABLE_SCHEMA, NULL, TABLE_NAME, CONSTRAINT_NAME ' +
              'FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE ' +
              'WHERE POSITION_IN_UNIQUE_CONSTRAINT IS NOT NULL ' +
              ' AND (TABLE_SCHEMA = :CATALOG_NAME OR (:CATALOG_NAME IS NULL)) AND (1=1 OR :SCHEMA_NAME IS NULL) AND (TABLE_NAME = :TABLE_NAME OR (:TABLE_NAME IS NULL)) ' +
              'GROUP BY 1,2,3,4 ' +
              'ORDER BY 1,2,3,4'
  else 
    Result := 'SHOW CREATE TABLE :TABLE_NAME';
end;

function TDBXMySqlMetaDataReader.GetSqlForForeignKeyColumns: WideString;
var
  CurrentVersion: WideString;
begin
  CurrentVersion := Version;
  if CurrentVersion >= '05.00.0006' then
    Result := 'SELECT TABLE_SCHEMA, NULL, TABLE_NAME, CONSTRAINT_NAME, COLUMN_NAME, REFERENCED_TABLE_SCHEMA, NULL, REFERENCED_TABLE_NAME, ''PRIMARY'', REFERENCED_COLUMN_NAME, ORDINAL_POSITION ' +
              'FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE ' +
              'WHERE POSITION_IN_UNIQUE_CONSTRAINT IS NOT NULL ' +
              ' AND (TABLE_SCHEMA = :CATALOG_NAME OR (:CATALOG_NAME IS NULL)) AND (1=1 OR :SCHEMA_NAME IS NULL) AND (TABLE_NAME = :TABLE_NAME OR (:TABLE_NAME IS NULL)) ' +
              ' AND (REFERENCED_TABLE_SCHEMA = :PRIMARY_CATALOG_NAME OR (:PRIMARY_CATALOG_NAME IS NULL)) AND (1=1 OR (:PRIMARY_SCHEMA_NAME IS NULL)) AND (REFERENCED_TABLE_NAME = :PRIMARY_TABLE_NAME OR (:PRIMARY_TABLE_NAME IS NULL)) AND (''PRIMARY'' = :PRIMARY_KEY_NAME OR ' + '(:PRIMARY_KEY_NAME IS NULL)) ' +
              'ORDER BY 1,2,3,4,ORDINAL_POSITION'
  else 
    Result := 'SHOW CREATE TABLE :TABLE_NAME';
end;

function TDBXMySqlMetaDataReader.FetchSynonyms(const CatalogName: WideString; const SchemaName: WideString; const SynonymName: WideString): TDBXTableStorage;
var
  Columns: TDBXColumnDescriptorArray;
begin
  Columns := TDBXMetaDataCollectionColumns.CreateSynonymsColumns;
  Result := TDBXBaseMetaDataReader.TDBXEmptyTableCursor.Create(TDBXMetaDataCollectionIndex.Synonyms, TDBXMetaDataCollectionName.Synonyms, Columns);
end;

function TDBXMySqlMetaDataReader.GetSqlForProcedures: WideString;
var
  CurrentVersion: WideString;
begin
  CurrentVersion := Version;
  if CurrentVersion >= '05.00.0006' then
{    Result := 'SELECT ROUTINE_SCHEMA, NULL, ROUTINE_NAME, ROUTINE_TYPE ' +
              'FROM INFORMATION_SCHEMA.ROUTINES ' +
              'WHERE (ROUTINE_SCHEMA = :CATALOG_NAME OR (:CATALOG_NAME IS NULL)) AND (1=1 OR (:SCHEMA_NAME IS NULL)) AND (ROUTINE_NAME = :PROCEDURE_NAME OR (:PROCEDURE_NAME IS NULL)) AND (ROUTINE_TYPE = :PROCEDURE_TYPE OR (:PROCEDURE_TYPE IS NULL)) ' +
              'ORDER BY 1, 2, 3'}
    // by TSV
{    Result := 'SELECT ROUTINE_SCHEMA, NULL, ROUTINE_NAME, ROUTINE_TYPE ' +
              'FROM INFORMATION_SCHEMA.ROUTINES ' +
              'WHERE (ROUTINE_SCHEMA = :SCHEMA_NAME OR (:SCHEMA_NAME IS NULL)) AND (1=1 OR (:SCHEMA_NAME IS NULL)) AND (ROUTINE_NAME = :PROCEDURE_NAME OR (:PROCEDURE_NAME IS NULL)) AND (ROUTINE_TYPE = :PROCEDURE_TYPE OR (:PROCEDURE_TYPE IS NULL)) ' +
              'ORDER BY 1, 2, 3'}
    Result := 'SELECT DB, NULL, NAME, TYPE ' +
              'FROM MYSQL.PROC ' +
              'WHERE (UPPER(DB) = :SCHEMA_NAME OR (:SCHEMA_NAME IS NULL)) AND (1=1 OR (:SCHEMA_NAME IS NULL)) AND (UPPER(NAME) = :PROCEDURE_NAME OR (:PROCEDURE_NAME IS NULL)) AND (UPPER(TYPE) = :PROCEDURE_TYPE OR (:PROCEDURE_TYPE IS NULL)) ' +
              'ORDER BY 1, 2, 3'
  else
    Result := 'EmptyTable';
end;

function TDBXMySqlMetaDataReader.GetSqlForProcedureSources: WideString;
begin
  Result := 'SHOW CREATE :PROCEDURE_TYPE :PROCEDURE_NAME';
end;

function TDBXMySqlMetaDataReader.GetSqlForProcedureParameters: WideString;
begin
  Result := 'SHOW CREATE :PROCEDURE_TYPE :PROCEDURE_NAME';
end;

function TDBXMySqlMetaDataReader.FetchPackages(const CatalogName: WideString; const SchemaName: WideString; const PackageName: WideString): TDBXTableStorage;
var
  Columns: TDBXColumnDescriptorArray;
begin
  Columns := TDBXMetaDataCollectionColumns.CreatePackagesColumns;
  Result := TDBXBaseMetaDataReader.TDBXEmptyTableCursor.Create(TDBXMetaDataCollectionIndex.Packages, TDBXMetaDataCollectionName.Packages, Columns);
end;

function TDBXMySqlMetaDataReader.FetchPackageProcedures(const CatalogName: WideString; const SchemaName: WideString; const PackageName: WideString; const ProcedureName: WideString; const ProcedureType: WideString): TDBXTableStorage;
var
  Columns: TDBXColumnDescriptorArray;
begin
  Columns := TDBXMetaDataCollectionColumns.CreatePackageProceduresColumns;
  Result := TDBXBaseMetaDataReader.TDBXEmptyTableCursor.Create(TDBXMetaDataCollectionIndex.PackageProcedures, TDBXMetaDataCollectionName.PackageProcedures, Columns);
end;

function TDBXMySqlMetaDataReader.FetchPackageProcedureParameters(const CatalogName: WideString; const SchemaName: WideString; const PackageName: WideString; const ProcedureName: WideString; const ParameterName: WideString): TDBXTableStorage;
var
  Columns: TDBXColumnDescriptorArray;
begin
  Columns := TDBXMetaDataCollectionColumns.CreatePackageProcedureParametersColumns;
  Result := TDBXBaseMetaDataReader.TDBXEmptyTableCursor.Create(TDBXMetaDataCollectionIndex.PackageProcedureParameters, TDBXMetaDataCollectionName.PackageProcedureParameters, Columns);
end;

function TDBXMySqlMetaDataReader.FetchPackageSources(const CatalogName: WideString; const SchemaName: WideString; const PackageName: WideString): TDBXTableStorage;
var
  Columns: TDBXColumnDescriptorArray;
begin
  Columns := TDBXMetaDataCollectionColumns.CreatePackageSourcesColumns;
  Result := TDBXBaseMetaDataReader.TDBXEmptyTableCursor.Create(TDBXMetaDataCollectionIndex.PackageSources, TDBXMetaDataCollectionName.PackageSources, Columns);
end;

function TDBXMySqlMetaDataReader.GetSqlForUsers: WideString;
var
  CurrentVersion: WideString;
begin
  CurrentVersion := Version;
  if CurrentVersion >= '05.00.0000' then
    Result := 'SELECT USER FROM MYSQL.USER'
  else 
    Result := 'EmptyTable';
end;

function TDBXMySqlMetaDataReader.FetchRoles: TDBXTableStorage;
var
  Columns: TDBXColumnDescriptorArray;
begin
  Columns := TDBXMetaDataCollectionColumns.CreateRolesColumns;
  Result := TDBXBaseMetaDataReader.TDBXEmptyTableCursor.Create(TDBXMetaDataCollectionIndex.Roles, TDBXMetaDataCollectionName.Roles, Columns);
end;

function TDBXMySqlMetaDataReader.GetDataTypeDescriptions: TDBXDataTypeDescriptionArray;
var
  Types: TDBXDataTypeDescriptionArray;
begin
  SetLength(Types,29);
  Types[0] := TDBXDataTypeDescription.Create('tinyint', TDBXDataTypesEx.Int8Type, 3, 'tinyint', NullString, -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.AutoIncrementable or TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.FixedPrecisionScale or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.UnsignedOption);
  Types[1] := TDBXDataTypeDescription.Create('smallint', TDBXDataTypes.Int16Type, 5, 'smallint', NullString, -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.AutoIncrementable or TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.FixedPrecisionScale or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.UnsignedOption);
  Types[2] := TDBXDataTypeDescription.Create('int', TDBXDataTypes.Int32Type, 10, 'int', NullString, -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.AutoIncrementable or TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.FixedPrecisionScale or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.UnsignedOption);
  Types[3] := TDBXDataTypeDescription.Create('mediumint', TDBXDataTypes.Int64Type, 19, 'mediumint', NullString, -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.AutoIncrementable or TDBXTypeFlag.FixedLength or TDBXTypeFlag.FixedPrecisionScale or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.UnsignedOption);
  Types[4] := TDBXDataTypeDescription.Create('bigint', TDBXDataTypes.Int64Type, 19, 'bigint', NullString, -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.AutoIncrementable or TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.FixedPrecisionScale or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.UnsignedOption);
  Types[5] := TDBXDataTypeDescription.Create('float', TDBXDataTypesEx.SingleType, 23, 'float', NullString, -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
  Types[6] := TDBXDataTypeDescription.Create('double', TDBXDataTypes.DoubleType, 53, 'double', NullString, -1, -1, NullString, NullString, NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
  Types[7] := TDBXDataTypeDescription.Create('decimal', TDBXDataTypes.BcdType, 64, 'decimal({0}, {1})', 'Precision, Scale', 64, 0, NullString, NullString, NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
  Types[8] := TDBXDataTypeDescription.Create('numeric', TDBXDataTypes.BcdType, 64, 'numeric({0}, {1})', 'Precision, Scale', 64, 0, NullString, NullString, NullString, NullString, TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
  Types[9] := TDBXDataTypeDescription.Create('timestamp', TDBXDataTypes.TimestampType, 4, 'timestamp', NullString, -1, -1, '{ts ''', '''}', NullString, NullString, TDBXTypeFlag.FixedLength or TDBXTypeFlag.Searchable or TDBXTypeFlag.ConcurrencyType);
  Types[10] := TDBXDataTypeDescription.Create('datetime', TDBXDataTypes.TimestampType, 8, 'datetime', NullString, -1, -1, '{ts ''', '''}', NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.SearchableWithLike);
  Types[11] := TDBXDataTypeDescription.Create('date', TDBXDataTypes.DateType, 3, 'date', NullString, -1, -1, '{ts ''', '''}', NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.SearchableWithLike);
  Types[12] := TDBXDataTypeDescription.Create('time', TDBXDataTypes.TimeType, 3, 'time', NullString, -1, -1, '{ts ''', '''}', NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.SearchableWithLike);
  Types[13] := TDBXDataTypeDescription.Create('year', TDBXDataTypes.Int32Type, 1, 'year', NullString, -1, -1, '{ts ''', '''}', NullString, NullString, TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.SearchableWithLike);
  Types[14] := TDBXDataTypeDescription.Create('binary', TDBXDataTypes.BytesType, 255, 'binary({0})', 'Precision', -1, -1, '0x', NullString, NullString, '05.00.0000', TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
  Types[15] := TDBXDataTypeDescription.Create('varbinary', TDBXDataTypes.VarbytesType, 254, 'varbinary({0})', 'Precision', -1, -1, '0x', NullString, '05.00.0002', NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
  Types[16] := TDBXDataTypeDescription.Create('varbinary', TDBXDataTypes.VarbytesType, 65533, 'varbinary({0})', 'Precision', -1, -1, '0x', NullString, NullString, '05.00.0003', TDBXTypeFlag.BestMatch or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable);
  Types[17] := TDBXDataTypeDescription.Create('char', TDBXDataTypes.AnsiStringType, 255, 'char({0})', 'Precision', -1, -1, '''', '''', NullString, '05.00.0000', TDBXTypeFlag.BestMatch or TDBXTypeFlag.FixedLength or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.SearchableWithLike);
  Types[18] := TDBXDataTypeDescription.Create('varchar', TDBXDataTypes.AnsiStringType, 254, 'varchar({0})', 'Precision', -1, -1, '''', '''', '05.00.0002', NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.SearchableWithLike);
  Types[19] := TDBXDataTypeDescription.Create('varchar', TDBXDataTypes.AnsiStringType, 65533, 'varchar({0})', 'Precision', -1, -1, '''', '''', NullString, '05.00.0003', TDBXTypeFlag.BestMatch or TDBXTypeFlag.Nullable or TDBXTypeFlag.Searchable or TDBXTypeFlag.SearchableWithLike);
  Types[20] := TDBXDataTypeDescription.Create('tinytext', TDBXDataTypes.AnsiStringType, 254, 'tinytext', NullString, -1, -1, '''', '''', NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.Long or TDBXTypeFlag.Nullable or TDBXTypeFlag.SearchableWithLike);
  Types[21] := TDBXDataTypeDescription.Create('text', TDBXDataTypes.AnsiStringType, 65533, 'text', NullString, -1, -1, '''', '''', NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.Long or TDBXTypeFlag.Nullable or TDBXTypeFlag.SearchableWithLike);
  Types[22] := TDBXDataTypeDescription.Create('mediumtext', TDBXDataTypes.AnsiStringType, 16777212, 'mediumtext', NullString, -1, -1, '''', '''', NullString, NullString, TDBXTypeFlag.Long or TDBXTypeFlag.Nullable or TDBXTypeFlag.SearchableWithLike);
  Types[23] := TDBXDataTypeDescription.Create('longtext', TDBXDataTypes.AnsiStringType, 4294967291, 'longtext', NullString, -1, -1, '''', '''', NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.Long or TDBXTypeFlag.Nullable or TDBXTypeFlag.SearchableWithLike);
  Types[24] := TDBXDataTypeDescription.Create('tinyblob', TDBXDataTypes.BlobType, 254, 'tinyblob', NullString, -1, -1, '''', '''', NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.Long or TDBXTypeFlag.Nullable);
  Types[25] := TDBXDataTypeDescription.Create('blob', TDBXDataTypes.BlobType, 65533, 'blob', NullString, -1, -1, '''', '''', NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.Long or TDBXTypeFlag.Nullable);
  Types[26] := TDBXDataTypeDescription.Create('mediumblob', TDBXDataTypes.BlobType, 16777212, 'mediumblob', NullString, -1, -1, '''', '''', NullString, NullString, TDBXTypeFlag.Long or TDBXTypeFlag.Nullable);
  Types[27] := TDBXDataTypeDescription.Create('longblob', TDBXDataTypes.BlobType, 4294967291, 'longblob', NullString, -1, -1, '''', '''', NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.Long or TDBXTypeFlag.Nullable);
  Types[28] := TDBXDataTypeDescription.Create('bool', TDBXDataTypes.BooleanType, 1, 'bool', NullString, -1, -1, '''', '''', NullString, NullString, TDBXTypeFlag.BestMatch or TDBXTypeFlag.Long or TDBXTypeFlag.Nullable);
  Result := Types;
end;

function TDBXMySqlMetaDataReader.GetReservedWords: TDBXWideStringArray;
var
  Words: TDBXWideStringArray;
begin
  SetLength(Words,225);
  Words[0] := 'ADD';
  Words[1] := 'ALL';
  Words[2] := 'ALTER';
  Words[3] := 'ANALYZE';
  Words[4] := 'AND';
  Words[5] := 'AS';
  Words[6] := 'ASC';
  Words[7] := 'ASENSITIVE';
  Words[8] := 'BEFORE';
  Words[9] := 'BETWEEN';
  Words[10] := 'BIGINT';
  Words[11] := 'BINARY';
  Words[12] := 'BLOB';
  Words[13] := 'BOTH';
  Words[14] := 'BY';
  Words[15] := 'CALL';
  Words[16] := 'CASCADE';
  Words[17] := 'CASE';
  Words[18] := 'CHANGE';
  Words[19] := 'CHAR';
  Words[20] := 'CHARACTER';
  Words[21] := 'CHECK';
  Words[22] := 'COLLATE';
  Words[23] := 'COLUMN';
  Words[24] := 'CONDITION';
  Words[25] := 'CONNECTION';
  Words[26] := 'CONSTRAINT';
  Words[27] := 'CONTINUE';
  Words[28] := 'CONVERT';
  Words[29] := 'CREATE';
  Words[30] := 'CROSS';
  Words[31] := 'CURRENT_DATE';
  Words[32] := 'CURRENT_TIME';
  Words[33] := 'CURRENT_TIMESTAMP';
  Words[34] := 'CURRENT_USER';
  Words[35] := 'CURSOR';
  Words[36] := 'DATABASE';
  Words[37] := 'DATABASES';
  Words[38] := 'DAY_HOUR';
  Words[39] := 'DAY_MICROSECOND';
  Words[40] := 'DAY_MINUTE';
  Words[41] := 'DAY_SECOND';
  Words[42] := 'DEC';
  Words[43] := 'DECIMAL';
  Words[44] := 'DECLARE';
  Words[45] := 'DEFAULT';
  Words[46] := 'DELAYED';
  Words[47] := 'DELETE';
  Words[48] := 'DESC';
  Words[49] := 'DESCRIBE';
  Words[50] := 'DETERMINISTIC';
  Words[51] := 'DISTINCT';
  Words[52] := 'DISTINCTROW';
  Words[53] := 'DIV';
  Words[54] := 'DOUBLE';
  Words[55] := 'DROP';
  Words[56] := 'DUAL';
  Words[57] := 'EACH';
  Words[58] := 'ELSE';
  Words[59] := 'ELSEIF';
  Words[60] := 'ENCLOSED';
  Words[61] := 'ESCAPED';
  Words[62] := 'EXISTS';
  Words[63] := 'EXIT';
  Words[64] := 'EXPLAIN';
  Words[65] := 'FALSE';
  Words[66] := 'FETCH';
  Words[67] := 'FLOAT';
  Words[68] := 'FLOAT4';
  Words[69] := 'FLOAT8';
  Words[70] := 'FOR';
  Words[71] := 'FORCE';
  Words[72] := 'FOREIGN';
  Words[73] := 'FROM';
  Words[74] := 'FULLTEXT';
  Words[75] := 'GOTO';
  Words[76] := 'GRANT';
  Words[77] := 'GROUP';
  Words[78] := 'HAVING';
  Words[79] := 'HIGH_PRIORITY';
  Words[80] := 'HOUR_MICROSECOND';
  Words[81] := 'HOUR_MINUTE';
  Words[82] := 'HOUR_SECOND';
  Words[83] := 'IF';
  Words[84] := 'IGNORE';
  Words[85] := 'IN';
  Words[86] := 'INDEX';
  Words[87] := 'INFILE';
  Words[88] := 'INNER';
  Words[89] := 'INOUT';
  Words[90] := 'INSENSITIVE';
  Words[91] := 'INSERT';
  Words[92] := 'INT';
  Words[93] := 'INT1';
  Words[94] := 'INT2';
  Words[95] := 'INT3';
  Words[96] := 'INT4';
  Words[97] := 'INT8';
  Words[98] := 'INTEGER';
  Words[99] := 'INTERVAL';
  Words[100] := 'INTO';
  Words[101] := 'IS';
  Words[102] := 'ITERATE';
  Words[103] := 'JOIN';
  Words[104] := 'KEY';
  Words[105] := 'KEYS';
  Words[106] := 'KILL';
  Words[107] := 'LABEL';
  Words[108] := 'LEADING';
  Words[109] := 'LEAVE';
  Words[110] := 'LEFT';
  Words[111] := 'LIKE';
  Words[112] := 'LIMIT';
  Words[113] := 'LINES';
  Words[114] := 'LOAD';
  Words[115] := 'LOCALTIME';
  Words[116] := 'LOCALTIMESTAMP';
  Words[117] := 'LOCK';
  Words[118] := 'LONG';
  Words[119] := 'LONGBLOB';
  Words[120] := 'LONGTEXT';
  Words[121] := 'LOOP';
  Words[122] := 'LOW_PRIORITY';
  Words[123] := 'MATCH';
  Words[124] := 'MEDIUMBLOB';
  Words[125] := 'MEDIUMINT';
  Words[126] := 'MEDIUMTEXT';
  Words[127] := 'MIDDLEINT';
  Words[128] := 'MINUTE_MICROSECOND';
  Words[129] := 'MINUTE_SECOND';
  Words[130] := 'MOD';
  Words[131] := 'MODIFIES';
  Words[132] := 'NATURAL';
  Words[133] := 'NO_WRITE_TO_BINLOG';
  Words[134] := 'NOT';
  Words[135] := 'NULL';
  Words[136] := 'NUMERIC';
  Words[137] := 'ON';
  Words[138] := 'OPTIMIZE';
  Words[139] := 'OPTION';
  Words[140] := 'OPTIONALLY';
  Words[141] := 'OR';
  Words[142] := 'ORDER';
  Words[143] := 'OUT';
  Words[144] := 'OUTER';
  Words[145] := 'OUTFILE';
  Words[146] := 'PRECISION';
  Words[147] := 'PRIMARY';
  Words[148] := 'PROCEDURE';
  Words[149] := 'PURGE';
  Words[150] := 'RAID0';
  Words[151] := 'READ';
  Words[152] := 'READS';
  Words[153] := 'REAL';
  Words[154] := 'REFERENCES';
  Words[155] := 'REGEXP';
  Words[156] := 'RELEASE';
  Words[157] := 'RENAME';
  Words[158] := 'REPEAT';
  Words[159] := 'REPLACE';
  Words[160] := 'REQUIRE';
  Words[161] := 'RESTRICT';
  Words[162] := 'RETURN';
  Words[163] := 'REVOKE';
  Words[164] := 'RIGHT';
  Words[165] := 'RLIKE';
  Words[166] := 'SCHEMA';
  Words[167] := 'SCHEMAS';
  Words[168] := 'SECOND_MICROSECOND';
  Words[169] := 'SELECT';
  Words[170] := 'SENSITIVE';
  Words[171] := 'SEPARATOR';
  Words[172] := 'SET';
  Words[173] := 'SHOW';
  Words[174] := 'SMALLINT';
  Words[175] := 'SONAME';
  Words[176] := 'SPATIAL';
  Words[177] := 'SPECIFIC';
  Words[178] := 'SQL';
  Words[179] := 'SQL_BIG_RESULT';
  Words[180] := 'SQL_CALC_FOUND_ROWS';
  Words[181] := 'SQL_SMALL_RESULT';
  Words[182] := 'SQLEXCEPTION';
  Words[183] := 'SQLSTATE';
  Words[184] := 'SQLWARNING';
  Words[185] := 'SSL';
  Words[186] := 'STARTING';
  Words[187] := 'STRAIGHT_JOIN';
  Words[188] := 'TABLE';
  Words[189] := 'TERMINATED';
  Words[190] := 'THEN';
  Words[191] := 'TINYBLOB';
  Words[192] := 'TINYINT';
  Words[193] := 'TINYTEXT';
  Words[194] := 'TO';
  Words[195] := 'TRAILING';
  Words[196] := 'TRIGGER';
  Words[197] := 'TRUE';
  Words[198] := 'UNDO';
  Words[199] := 'UNION';
  Words[200] := 'UNIQUE';
  Words[201] := 'UNLOCK';
  Words[202] := 'UNSIGNED';
  Words[203] := 'UPDATE';
  Words[204] := 'UPGRADE';
  Words[205] := 'USAGE';
  Words[206] := 'USE';
  Words[207] := 'USING';
  Words[208] := 'UTC_DATE';
  Words[209] := 'UTC_TIME';
  Words[210] := 'UTC_TIMESTAMP';
  Words[211] := 'VALUES';
  Words[212] := 'VARBINARY';
  Words[213] := 'VARCHAR';
  Words[214] := 'VARCHARACTER';
  Words[215] := 'VARYING';
  Words[216] := 'WHEN';
  Words[217] := 'WHERE';
  Words[218] := 'WHILE';
  Words[219] := 'WITH';
  Words[220] := 'WRITE';
  Words[221] := 'X509';
  Words[222] := 'XOR';
  Words[223] := 'YEAR_MONTH';
  Words[224] := 'ZEROFILL';
  Result := Words;
end;

end.