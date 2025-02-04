using CommitAndForget.Essentials;

namespace CommitAndForget.Model
{
  public class BestellungsModel : NotifyObject
  {
    #region Properties
    public int Key
    {
      get => Get<int>();
      set => Set(value);
    }

    public DateTime Bestelldatum
    {
      get => Get<DateTime>();
      set => Set(value);
    }

    public int BenutzerLink
    {
      get => Get<int>();
      set => Set(value);
    }

    public int RechnungsLink
    {
      get => Get<int>();
      set => Set(value);
    }
    #endregion Properties
  }
}
