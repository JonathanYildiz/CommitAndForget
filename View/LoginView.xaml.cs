using CommitAndForget.ViewModel;
using System.Windows;
using System.Windows.Controls;

namespace CommitAndForget
{
  public partial class LoginView : Window
  {
    public LoginView()
    {
      InitializeComponent();
      DataContext = new LoginViewModel();
    }
    private void PasswordBox_PasswordChanged(object sender, RoutedEventArgs e)
    {
      if (this.DataContext != null)
      { ((dynamic)this.DataContext).Password = ((PasswordBox)sender).Password; }
    }
  }
}