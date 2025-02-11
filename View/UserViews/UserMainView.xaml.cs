using System.Windows;
using CommitAndForget.View.UserViews;
using CommitAndForget.ViewModel;

namespace CommitAndForget.View
{
  public partial class UserMainView : Window
  {
    public UserMainView()
    {
      InitializeComponent();
    }

    private void Window_Loaded(object sender, RoutedEventArgs e)
    {
      var view = new SelectionView();
      view.DataContext = DataContext;
      ((UserViewModel)DataContext).MainFrame = MainFrame; // Mainframe aus XAML in ViewModel durchreichen
      MainFrame.Navigate(view);
    }
  }
}
