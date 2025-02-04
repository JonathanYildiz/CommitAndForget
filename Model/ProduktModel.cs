using CommitAndForget.Essentials;

namespace CommitAndForget.Model
{
  public class ProduktModel : NotifyObject
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

    public int Energie
    {
      get => Get<int>();
      set => Set(value);
    }

    public double Preis
    {
      get => Get<double>();
      set => Set(value);
    }

    public int BildLink
    {
      get => Get<int>();
      set => Set(value);
    }
    #endregion Properties
  }
}
