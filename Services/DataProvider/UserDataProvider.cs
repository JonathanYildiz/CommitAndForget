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
          { "p_Key",         user.Key },
          { "p_FirstName",   string.IsNullOrWhiteSpace(user.FirstName)   ? DBNull.Value : user.FirstName },
          { "p_LastName",    string.IsNullOrWhiteSpace(user.LastName)    ? DBNull.Value : user.LastName },
          { "p_Street",      string.IsNullOrWhiteSpace(user.Street)      ? DBNull.Value : user.Street },
          { "p_HouseNumber", string.IsNullOrWhiteSpace(user.HouseNumber) ? DBNull.Value : user.HouseNumber },
          { "p_PostalCode",  string.IsNullOrWhiteSpace(user.PostalCode)  ? DBNull.Value : user.PostalCode },
          { "p_City",        string.IsNullOrWhiteSpace(user.City)        ? DBNull.Value : user.City },
          { "p_Email",       string.IsNullOrWhiteSpace(user.Email)       ? DBNull.Value : user.Email },
          { "p_Password",    string.IsNullOrWhiteSpace(user.Password)    ? DBNull.Value : user.Password },
          { "p_IsAdmin",     user.IsAdmin }
        };
        DataBaseService.ExecuteSP("spUpdateUser", parameters);
      }
      catch (Exception ex)
      {
        MessageBoxService.DisplayMessage(ex.Message, MessageBoxImage.Error);
      }
    }

    public static void GetUsersFavorites(UserModel user)
    {
      try
      {
        var parameters = new Dictionary<string, object>
        {
          { "p_UserLink", user.Key }
        };

        // Lieblingprodukt laden
        DataTable dt = DataBaseService.ExecuteSP("spGetUsersFavoriteProduct", parameters);
        if (dt is not null && dt.Rows.Count == 1)
        {
          // Lieblingsprodukt setzen
          user.MostOrderedProduct = dt.Rows[0]["product_Name"] != DBNull.Value ? dt.Rows[0]["product_Name"].ToString() ?? string.Empty : string.Empty;

          // Anzahl der Bestellungen setzen
          if (!string.IsNullOrEmpty(user.MostOrderedProduct))
          {
            user.MostOrderedProduct += " (";
            user.MostOrderedProduct += dt.Rows[0]["product_Count"] != DBNull.Value ? dt.Rows[0]["product_Count"].ToString() ?? string.Empty : string.Empty;
            user.MostOrderedProduct += ")";
          }
        }

        dt = DataBaseService.ExecuteSP("spGetUsersFavoriteMenu", parameters);
        if (dt is not null && dt.Rows.Count == 1)
        {
          // Lieblingsmenü setzen
          user.MostOrderedMenu = dt.Rows[0]["menu_Name"] != DBNull.Value ? dt.Rows[0]["menu_Name"].ToString() ?? string.Empty : string.Empty;

          // Anzahl der Bestellungen setzen
          if (!string.IsNullOrEmpty(user.MostOrderedMenu))
          {
            user.MostOrderedMenu += " (";
            user.MostOrderedMenu += dt.Rows[0]["menu_Count"] != DBNull.Value ? dt.Rows[0]["menu_Count"].ToString() ?? string.Empty : string.Empty;
            user.MostOrderedMenu += ")";
          }
        }
      }
      catch (Exception ex)
      {
        MessageBoxService.DisplayMessage(ex.Message, MessageBoxImage.Error);
      }
    }
  }
}