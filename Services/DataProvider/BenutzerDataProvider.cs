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
            benutzer.Passwort = row["szPasswort"] != DBNull.Value ? row["szPasswort"].ToString() ?? string.Empty : string.Empty;
            benutzer.IsAdmin = row["bIsAdmin"] != DBNull.Value ? (bool)row["bIsAdmin"] : default;

            benutzerListe.Add(benutzer);
          }
        }
        return benutzerListe;
      }
      catch (Exception ex)
      {
        MessageBox.Show($"Es ist ein Fehler aufgetreten: {ex.Message}", "Fehler", MessageBoxButton.OK, MessageBoxImage.Error);
        return [];
      }
    }
  }
}
