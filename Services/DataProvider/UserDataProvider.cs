using System.Collections.ObjectModel;
using System.Data;
using System.Windows;
using CommitAndForget.Model;

namespace CommitAndForget.Services.DataProvider
{
  public static class UserDataProvider
  {
    public static ObservableCollection<UserModel> LoadUser()
    {
      try
      {
        DataTable dt = DataBaseService.ExecuteSP("spLoadUsers");
        var userList = new ObservableCollection<UserModel>();

        if (dt is not null && dt.Rows.Count > 0)
        {
          foreach (DataRow row in dt.Rows)
          {
            var user = new UserModel();

            user.Key = row["nKey"] != DBNull.Value ? (int)row["nKey"] : default;
            user.FirstName = row["szFirstName"] != DBNull.Value ? row["szFirstName"].ToString() ?? string.Empty : string.Empty;
            user.LastName = row["szLastName"] != DBNull.Value ? row["szLastName"].ToString() ?? string.Empty : string.Empty;
            user.Street = row["szStreet"] != DBNull.Value ? row["szStreet"].ToString() ?? string.Empty : string.Empty;
            user.HouseNumber = row["szHouseNumber"] != DBNull.Value ? row["szHouseNumber"].ToString() ?? string.Empty : string.Empty;
            user.PostalCode = row["szPostalCode"] != DBNull.Value ? row["szPostalCode"].ToString() ?? string.Empty : string.Empty;
            user.City = row["szCity"] != DBNull.Value ? row["szCity"].ToString() ?? string.Empty : string.Empty;
            user.Email = row["szEmail"] != DBNull.Value ? row["szEmail"].ToString() ?? string.Empty : string.Empty;
            user.IsAdmin = row["bIsAdmin"] != DBNull.Value ? Convert.ToBoolean(row["bIsAdmin"]) : default;

            userList.Add(user);
          }
        }
        return userList;
      }
      catch (Exception ex)
      {
        MessageBoxService.DisplayMessage(ex.Message, MessageBoxImage.Error);
        return [];
      }
    }

    public static UserModel Login(string mail, string password)
    {
      var user = new UserModel();
      try
      {
        var parameters = new Dictionary<string, object>
        {
          { "p_Email", mail },
          { "p_Password", password }
        };
        DataTable dt = DataBaseService.ExecuteSP("spLogin", parameters);

        if (dt is not null && dt.Rows.Count == 1) // Es darf nur ein Benutzer zurückkommmen
        {
          user.Key = dt.Rows[0]["nKey"] != DBNull.Value ? (int)dt.Rows[0]["nKey"] : default;
          user.FirstName = dt.Rows[0]["szFirstName"] != DBNull.Value ? dt.Rows[0]["szFirstName"].ToString() ?? string.Empty : string.Empty;
          user.LastName = dt.Rows[0]["szLastName"] != DBNull.Value ? dt.Rows[0]["szLastName"].ToString() ?? string.Empty : string.Empty;
          user.Street = dt.Rows[0]["szStreet"] != DBNull.Value ? dt.Rows[0]["szStreet"].ToString() ?? string.Empty : string.Empty;
          user.HouseNumber = dt.Rows[0]["szHouseNumber"] != DBNull.Value ? dt.Rows[0]["szHouseNumber"].ToString() ?? string.Empty : string.Empty;
          user.PostalCode = dt.Rows[0]["szPostalCode"] != DBNull.Value ? dt.Rows[0]["szPostalCode"].ToString() ?? string.Empty : string.Empty;
          user.City = dt.Rows[0]["szCity"] != DBNull.Value ? dt.Rows[0]["szCity"].ToString() ?? string.Empty : string.Empty;
          user.Email = dt.Rows[0]["szEmail"] != DBNull.Value ? dt.Rows[0]["szEmail"].ToString() ?? string.Empty : string.Empty;
          user.IsAdmin = dt.Rows[0]["bIsAdmin"] != DBNull.Value ? Convert.ToBoolean(dt.Rows[0]["bIsAdmin"]) : default;
        }

        return user;
      }
      catch (Exception ex)
      {
        MessageBoxService.DisplayMessage(ex.Message, MessageBoxImage.Error);
        return user;
      }
    }

    public static UserModel Register(UserModel newUser)
    {
      var user = new UserModel();
      try
      {
        var parameters = new Dictionary<string, object>
        {
          { "p_FirstName", newUser.FirstName },
          { "p_LastName", newUser.LastName },
          { "p_Street", newUser.Street },
          { "p_HouseNumber", newUser.HouseNumber },
          { "p_PostalCode", newUser.PostalCode },
          { "p_City", newUser.City },
          { "p_Email", newUser.Email },
          { "p_Password", newUser.Password },
          { "p_IsAdmin", newUser.IsAdmin }
        };
        DataTable dt = DataBaseService.ExecuteSP("spRegisterUser", parameters);

        if (dt is not null && dt.Rows.Count == 1) // Es darf nur ein Benutzer zurückkommmen
        {
          if (dt.Columns.Contains("Nachricht") && dt.Rows[0]["Nachricht"] != DBNull.Value) // Fehlermeldungen aus der Datenbank abfangen
            return null;

          user.Key = dt.Rows[0]["nKey"] != DBNull.Value ? (int)dt.Rows[0]["nKey"] : default;
          user.FirstName = dt.Rows[0]["szFirstName"] != DBNull.Value ? dt.Rows[0]["szFirstName"].ToString() ?? string.Empty : string.Empty;
          user.LastName = dt.Rows[0]["szLastName"] != DBNull.Value ? dt.Rows[0]["szLastName"].ToString() ?? string.Empty : string.Empty;
          user.Street = dt.Rows[0]["szStreet"] != DBNull.Value ? dt.Rows[0]["szStreet"].ToString() ?? string.Empty : string.Empty;
          user.HouseNumber = dt.Rows[0]["szHouseNumber"] != DBNull.Value ? dt.Rows[0]["szHouseNumber"].ToString() ?? string.Empty : string.Empty;
          user.PostalCode = dt.Rows[0]["szPostalCode"] != DBNull.Value ? dt.Rows[0]["szPostalCode"].ToString() ?? string.Empty : string.Empty;
          user.City = dt.Rows[0]["szCity"] != DBNull.Value ? dt.Rows[0]["szCity"].ToString() ?? string.Empty : string.Empty;
          user.Email = dt.Rows[0]["szEmail"] != DBNull.Value ? dt.Rows[0]["szEmail"].ToString() ?? string.Empty : string.Empty;
          user.IsAdmin = dt.Rows[0]["bIsAdmin"] != DBNull.Value ? Convert.ToBoolean(dt.Rows[0]["bIsAdmin"]) : default;
        }
        return user;
      }
      catch (Exception ex)
      {
        MessageBoxService.DisplayMessage(ex.Message, MessageBoxImage.Error);
        return user;
      }
    }

    public static void DeleteUser(int key)
    {
      try
      {
        var parameters = new Dictionary<string, object> { { "p_Key", key } };
        DataBaseService.ExecuteSP("spDeleteUser", parameters);
      }
      catch (Exception ex)
      {
        MessageBoxService.DisplayMessage(ex.Message, MessageBoxImage.Error);
      }
    }

    public static void UpdateUser(UserModel user)
    {
      try
      {
        var parameters = new Dictionary<string, object>
        {
          { "p_Key", user.Key },
          { "p_FirstName", user.FirstName },
          { "p_LastName", user.LastName },
          { "p_Street", user.Street },
          { "p_HouseNumber", user.HouseNumber },
          { "p_PostalCode", user.PostalCode },
          { "p_City", user.City },
          { "p_Email", user.Email },
          { "p_Password", user.Password },
          { "p_IsAdmin", user.IsAdmin }
        };
        DataBaseService.ExecuteSP("spUpdateUser", parameters);
      }
      catch (Exception ex)
      {
        MessageBoxService.DisplayMessage(ex.Message, MessageBoxImage.Error);
      }
    }
  }
}