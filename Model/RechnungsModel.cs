using CommitAndForget.Essentials;

namespace CommitAndForget.Model
{
  public class RechnungsModel : NotifyObject
  {
    #region Properties
    public int Key
    {
      get => Get<int>();
      set => Set(value);
    }

    public int Rechnungsnummer
    {
      get => Get<int>();
      set => Set(value);
    }

    public bool Bezahlt
    {
      get => Get<bool>();
      set => Set(value);
    }

    public string Bezahlart
    {
      get => Get<string>();
      set => Set(value);
    }
    #endregion Properties
  }
}
