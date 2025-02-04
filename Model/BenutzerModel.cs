using CommitAndForget.Essentials;

namespace CommitAndForget.Model
{
  public class BenutzerModel : NotifyObject
  {
    #region Properties
    public int Key
    {
      get => Get<int>();
      set => Set(value);
    }

    public string Name
    {
      get => Get<string>();
      set => Set(value);
    }

    public string Strasse
    {
      get => Get<string>();
      set => Set(value);
    }

    public int Hausnummer
    {
      get => Get<int>();
      set => Set(value);
    }

    public string Postleitzahl
    {
      get => Get<string>();
      set => Set(value);
    }

    public string Wohnort
    {
      get => Get<string>();
      set => Set(value);
    }

    public string Mail
    {
      get => Get<string>();
      set => Set(value);
    }

    public string Passwort
    {
      get => Get<string>();
      set => Set(value);
    }

    public bool IsAdmin
    {
      get => Get<bool>();
      set => Set(value);
    }
    #endregion Properties
  }
}
