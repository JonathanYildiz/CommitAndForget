using CommitAndForget.Essentials;

namespace CommitAndForget.Model
{
  public class ProductModel : NotifyObject
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

    public int Energy
    {
      get => Get<int>();
      set => Set(value);
    }

    public double Price
    {
      get => Get<double>();
      set => Set(value);
    }

    public int ImageLink
    {
      get => Get<int>();
      set => Set(value);
    }
    #endregion Properties
  }
}
