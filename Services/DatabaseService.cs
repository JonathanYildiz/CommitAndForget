using System.Data;
using System.Windows;
using MySql.Data.MySqlClient;

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
        Database = "commitandforget",
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
        MessageBox.Show($"Es ist ein Fehler aufgetreten: {ex.Message}", "Fehler", MessageBoxButton.OK, MessageBoxImage.Error);
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
          }
        }
      }
      catch (Exception ex)
      {
        MessageBox.Show($"Es ist ein Fehler aufgetreten: {ex.Message}", "Fehler", MessageBoxButton.OK, MessageBoxImage.Error);
      }
      return tbl;
    }

    public static DataSet ExecuteSPDataSet(string sp, Dictionary<string, object> parameters)
    {
      DataSet dataSet = new DataSet();
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
            adapter.Fill(dataSet);
          }
        }
      }
      catch (Exception ex)
      {
        MessageBox.Show($"Es ist ein Fehler aufgetreten: {ex.Message}", "Fehler", MessageBoxButton.OK, MessageBoxImage.Error);
      }
      return dataSet;
    }

    public static DataSet ExecuteSPDataSet(string sp)
    {
      DataSet dataSet = new DataSet();
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
            adapter.Fill(dataSet);
          }
        }
      }
      catch (Exception ex)
      {
        MessageBox.Show($"Es ist ein Fehler aufgetreten: {ex.Message}", "Fehler", MessageBoxButton.OK, MessageBoxImage.Error);
      }
      return dataSet;
    }
  }
}