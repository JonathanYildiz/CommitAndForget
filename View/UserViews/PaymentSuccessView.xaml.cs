using System.Windows.Controls;

namespace CommitAndForget.View.UserViews
{
  public partial class PaymentSuccessView : Page
  {
    public PaymentSuccessView(string paymentMethod)
    {
      InitializeComponent();
      PaymentLabel.Content = "Erfolgreich per " + paymentMethod + " bezahlt!";
    }
  }
}
