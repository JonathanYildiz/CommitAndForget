using CommitAndForget.Essentials;

namespace CommitAndForget.Model
{
  public class InvoiceModel : NotifyObject
  {
    #region Properties
    public int Key
    {
      get => Get<int>();
      set => Set(value);
    }

    public int InvoiceNumber
    {
      get => Get<int>();
      set => Set(value);
    }

    public bool Paid
    {
      get => Get<bool>();
      set => Set(value);
    }

    public string PaymentMethod
    {
      get => Get<string>();
      set => Set(value);
    }
    #endregion Properties
  }
}
