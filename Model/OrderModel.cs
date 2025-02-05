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

    public int UserLink
    {
      get => Get<int>();
      set => Set(value);
    }

    public int InvoiceLink
    {
      get => Get<int>();
      set => Set(value);
    }
    #endregion Properties
  }
}
