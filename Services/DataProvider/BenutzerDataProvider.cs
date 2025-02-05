using System.Collections.ObjectModel;
using System.Data;
using System.Windows;
using CommitAndForget.Model;

namespace CommitAndForget.Services.DataProvider
{
  public static class BenutzerDataProvider
  {
    public static ObservableCollection<BenutzerModel> LoadBenutzer()
    {
      try
      {
        DataTable dt = DataBaseService.ExecuteSP("spLoadBenutzer");
        var benutzerListe = new ObservableCollection<BenutzerModel>();

        if (dt is not null && dt.Rows.Count > 0)
        {
          foreach (DataRow row in dt.Rows)
          {
            var benutzer = new BenutzerModel();

            benutzer.Key = row["nKey"] != DBNull.Value ? (int)row["nKey"] : default;
            benutzer.Name = row["szName"] != DBNull.Value ? row["szName"].ToString() ?? string.Empty : string.Empty;
            benutzer.Strasse = row["szStrasse"] != DBNull.Value ? row["szStrasse"].ToString() ?? string.Empty : string.Empty;
            benutzer.Hausnummer = row["nHausnummer"] != DBNull.Value ? (int)row["nHausnummer"] : default;
            benutzer.Postleitzahl = row["szPostleitzahl"] != DBNull.Value ? row["szPostleitzahl"].ToString() ?? string.Empty : string.Empty;
            benutzer.Wohnort = row["szWohnort"] != DBNull.Value ? row["szWohnort"].ToString() ?? string.Empty : string.Empty;
            benutzer.Mail = row["szMail"] != DBNull.Value ? row["szMail"].ToString() ?? string.Empty : string.Empty;
            benutzer.IsAdmin = row["bIsAdmin"] != DBNull.Value ? Convert.ToBoolean(row["bIsAdmin"]) : default;

            benutzerListe.Add(benutzer);
          }
        }
        return benutzerListe;
      }
      catch (Exception ex)
      {
        MessageBoxService.DisplayMessage(ex.Message, MessageBoxImage.Error);
        return [];
      }
    }

    public static BenutzerModel Login(string mail, string passwort)
    {
      var benutzer = new BenutzerModel();
      try
      {
        var parameters = new Dictionary<string, object>
        {
          { "p_Mail", mail },
          { "p_Passwort", passwort }
        };
        DataTable dt = DataBaseService.ExecuteSP("spLogin", parameters);

        if (dt is not null && dt.Rows.Count == 1) // Es darf nur ein Benutzer zurückkommmen
        {
          benutzer.Key = dt.Rows[0]["nKey"] != DBNull.Value ? (int)dt.Rows[0]["nKey"] : default;
          benutzer.Name = dt.Rows[0]["szName"] != DBNull.Value ? dt.Rows[0]["szName"].ToString() ?? string.Empty : string.Empty;
          benutzer.Strasse = dt.Rows[0]["szStrasse"] != DBNull.Value ? dt.Rows[0]["szStrasse"].ToString() ?? string.Empty : string.Empty;
          benutzer.Hausnummer = dt.Rows[0]["nHausnummer"] != DBNull.Value ? (int)dt.Rows[0]["nHausnummer"] : default;
          benutzer.Postleitzahl = dt.Rows[0]["szPostleitzahl"] != DBNull.Value ? dt.Rows[0]["szPostleitzahl"].ToString() ?? string.Empty : string.Empty;
          benutzer.Wohnort = dt.Rows[0]["szWohnort"] != DBNull.Value ? dt.Rows[0]["szWohnort"].ToString() ?? string.Empty : string.Empty;
          benutzer.Mail = dt.Rows[0]["szMail"] != DBNull.Value ? dt.Rows[0]["szMail"].ToString() ?? string.Empty : string.Empty;
          benutzer.IsAdmin = dt.Rows[0]["bIsAdmin"] != DBNull.Value ? Convert.ToBoolean(dt.Rows[0]["bIsAdmin"]) : default;
        }

        return benutzer;
      }
      catch (Exception ex)
      {
        MessageBoxService.DisplayMessage(ex.Message, MessageBoxImage.Error);
        return benutzer;
      }      
    }

    public static BenutzerModel Registrieren(BenutzerModel neuerBenutzer)
    {
      var benutzer = new BenutzerModel();
      try
      {
        var parameters = new Dictionary<string, object>
        {
          { "p_Name", neuerBenutzer.Name },
          { "p_Strasse", neuerBenutzer.Strasse },
          { "p_Hausnummer", neuerBenutzer.Hausnummer },
          { "p_Postleitzahl", neuerBenutzer.Postleitzahl },
          { "p_Wohnort", neuerBenutzer.Wohnort },
          { "p_Mail", neuerBenutzer.Mail },
          { "p_Passwort", neuerBenutzer.Passwort }
        };
        DataTable dt = DataBaseService.ExecuteSP("spRegistrieren", parameters);

        if (dt is not null && dt.Rows.Count == 1) // Es darf nur ein Benutzer zurückkommmen
        {
          // TODO JYI SQL Fehlermeldung abfangen, wenn Email bereits verwendet wird

          benutzer.Key = dt.Rows[0]["nKey"] != DBNull.Value ? (int)dt.Rows[0]["nKey"] : default;
          benutzer.Name = dt.Rows[0]["szName"] != DBNull.Value ? dt.Rows[0]["szName"].ToString() ?? string.Empty : string.Empty;
          benutzer.Strasse = dt.Rows[0]["szStrasse"] != DBNull.Value ? dt.Rows[0]["szStrasse"].ToString() ?? string.Empty : string.Empty;
          benutzer.Hausnummer = dt.Rows[0]["nHausnummer"] != DBNull.Value ? (int)dt.Rows[0]["nHausnummer"] : default;
          benutzer.Postleitzahl = dt.Rows[0]["szPostleitzahl"] != DBNull.Value ? dt.Rows[0]["szPostleitzahl"].ToString() ?? string.Empty : string.Empty;
          benutzer.Wohnort = dt.Rows[0]["szWohnort"] != DBNull.Value ? dt.Rows[0]["szWohnort"].ToString() ?? string.Empty : string.Empty;
          benutzer.Mail = dt.Rows[0]["szMail"] != DBNull.Value ? dt.Rows[0]["szMail"].ToString() ?? string.Empty : string.Empty;
          benutzer.IsAdmin = dt.Rows[0]["bIsAdmin"] != DBNull.Value ? Convert.ToBoolean(dt.Rows[0]["bIsAdmin"]) : default;
        }
        return benutzer;
      }
      catch (Exception ex)
      {
        MessageBoxService.DisplayMessage(ex.Message, MessageBoxImage.Error);
        return benutzer;
      }
    }
  }
}