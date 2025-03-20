using MySql.Data.MySqlClient;
using System.Data;
using System.Windows;

namespace CommitAndForget.Services
{
  public class DataBaseService
  {
    private static readonly string ConnectionString;

    static DataBaseService()
    {
      ConnectionString = new MySqlConnectionStringBuilder()
      {
        Server = "127.0.0.1",
        Database = "dbcommitandforget",
        UserID = "root",
        Password = "",
        SslMode = MySqlSslMode.Disabled
      }.ConnectionString;

    }

    public static DataTable ExecuteSP(string sp)
    {
      DataTable tbl = new DataTable();
      try
      {
        using (MySqlConnection connection = new MySqlConnection(ConnectionString))
        {
          MySqlCommand command = new MySqlCommand(sp, connection)
          {
            CommandType = CommandType.StoredProcedure
          };

          using (MySqlDataAdapter adapter = new MySqlDataAdapter(command))
          {
            adapter.Fill(tbl);
          }
        }
      }
      catch (Exception ex)
      {
        MessageBoxService.DisplayMessage(ex.Message, MessageBoxImage.Error);
        tbl.ExtendedProperties["HasErrors"] = true;
      }
      return tbl;
    }

    public static DataTable ExecuteSP(string sp, Dictionary<string, object> parameters)
    {
      DataTable tbl = new DataTable();
      try
      {
        using (MySqlConnection connection = new MySqlConnection(ConnectionString))
        {
          MySqlCommand command = new MySqlCommand(sp, connection)
          {
            CommandType = CommandType.StoredProcedure
          };
          foreach (KeyValuePair<string, object> item in parameters)
          {
            command.Parameters.AddWithValue(item.Key, item.Value ?? DBNull.Value);
          }
          using (MySqlDataAdapter adapter = new MySqlDataAdapter(command))
          {
            adapter.Fill(tbl);

            // Fehlermeldungen abfangen
            if (tbl is not null && tbl.Rows.Count == 1)
              if (tbl.Columns.Contains("Nachricht") && tbl.Rows[0]["Nachricht"] != DBNull.Value)
                MessageBoxService.DisplayMessage(tbl.Rows[0]["Nachricht"].ToString() ?? "DB-Fehler", MessageBoxImage.Warning);
          }
        }
      }
      catch (Exception ex)
      {
        MessageBoxService.DisplayMessage(ex.Message, MessageBoxImage.Error);
        tbl.ExtendedProperties["HasErrors"] = true;
      }
      return tbl;
    }
  }
}