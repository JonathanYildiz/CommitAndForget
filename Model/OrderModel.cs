using CommitAndForget.Essentials;

namespace CommitAndForget.Model
{
  public class OrderModel : NotifyObject
  {
    #region Properties
    public int Key
    {
      get => Get<int>();
      set => Set(value);
    }

    public DateTime OrderDate
    {
      get => Get<DateTime>();
      set => Set(value);
    }

    public string UserMail
    {
      get => Get<string>();
      set => Set(value);
    }

    public double TotalPrice
    {
      get => Get<double>();
      set => Set(value);
    }

    #endregion Properties
  }
}
