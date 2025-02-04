using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using Microsoft.Data.SqlClient;

namespace CommitAndForget.Services
{
  public class DataBaseService
  {

    private static readonly string ConnectionString;
    private static readonly string ConnectionStringWithoutEncryption;
    static DataBaseService()
    {
      ConnectionString = new SqlConnectionStringBuilder()
      {
        DataSource = "85.215.35.160",
        InitialCatalog = "dbWorkshopManager",
        UserID = "WorkshopManagerUser",
        Password = "AGA$U7TU%§uxckYc",
        TrustServerCertificate = true
      }.ConnectionString;

      ConnectionStringWithoutEncryption = new SqlConnectionStringBuilder()
      {
        DataSource = "85.215.35.160",
        InitialCatalog = "dbWorkshopManager",
        UserID = "WorkshopManagerUser",
        Password = "AGA$U7TU%§uxckYc",
        TrustServerCertificate = true,
        Encrypt = false
      }.ConnectionString;
    }
    public static DataTable ExecuteSP(string sp)
    {
      DataTable tbl = new DataTable();
      try
      {
        using (SqlConnection connection = new SqlConnection(ConnectionString))
        {
          SqlCommand command = new SqlCommand(sp, connection)
          {
            CommandType = CommandType.StoredProcedure
          };

          using (SqlDataAdapter adapter = new SqlDataAdapter(command))
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

    // TODO JYI prüfen, ob encryption ausschalten zum Bilder hochladen hier überhaupt notwendig ist
    public static DataTable ExecuteSP(string sp, Dictionary<string, object> parameters, bool encrypt = true)
    {
      DataTable tbl = new DataTable();
      try
      {
        using (SqlConnection connection = new SqlConnection(encrypt ? ConnectionString : ConnectionStringWithoutEncryption))
        {
          SqlCommand command = new SqlCommand(sp, connection)
          {
            CommandType = CommandType.StoredProcedure
          };
          foreach (KeyValuePair<string, object> item in parameters)
          {
            if (item.Value is DateTime dateTimeValue)
              command.Parameters.Add(new SqlParameter(item.Key, SqlDbType.DateTime) { Value = dateTimeValue });
            else if (item.Value is decimal decimalValue)
              command.Parameters.Add(new SqlParameter(item.Key, SqlDbType.Decimal) { Value = decimalValue });
            else if (item.Value is string stringValue)
              command.Parameters.Add(new SqlParameter(item.Key, SqlDbType.NVarChar) { Value = stringValue });
            else if (item.Value is byte[] imageValue)
              command.Parameters.Add(new SqlParameter(item.Key, SqlDbType.VarBinary) { Value = imageValue });
            else if (item.Value is null)
              command.Parameters.Add(new SqlParameter(item.Key, DBNull.Value));
            else
              command.Parameters.Add(new SqlParameter(item.Key, item.Value ?? DBNull.Value));
          }
          using (SqlDataAdapter adapter = new SqlDataAdapter(command))
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
        using (SqlConnection connection = new SqlConnection(ConnectionString))
        {
          SqlCommand command = new SqlCommand(sp, connection)
          {
            CommandType = CommandType.StoredProcedure
          };

          foreach (KeyValuePair<string, object> item in parameters)
          {
            SqlParameter parameter = new SqlParameter(item.Key, item.Value ?? DBNull.Value);

            if (item.Value is DateTime)
              parameter.SqlDbType = SqlDbType.DateTime;
            else if (item.Value is decimal)
              parameter.SqlDbType = SqlDbType.Decimal;
            else if (item.Value is string)
              parameter.SqlDbType = SqlDbType.NVarChar;
            else if (item.Value is byte[])
              parameter.SqlDbType = SqlDbType.VarBinary;

            command.Parameters.Add(parameter);
          }

          using (SqlDataAdapter adapter = new SqlDataAdapter(command))
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
        using (SqlConnection connection = new SqlConnection(ConnectionString))
        {
          SqlCommand command = new SqlCommand(sp, connection)
          {
            CommandType = CommandType.StoredProcedure
          };


          using (SqlDataAdapter adapter = new SqlDataAdapter(command))
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
