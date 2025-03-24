using CommitAndForget.View.AdminViews;
using CommitAndForget.View.UserViews;
using CommitAndForget.ViewModel;
using System.Windows;

namespace CommitAndForget.View
{
  public partial class MainView : Window
  {
    public MainView()
    {
      InitializeComponent();
    }

    private void Window_Loaded(object sender, RoutedEventArgs e)
    {
      if (DataContext is UserViewModel userVM)
      {
        var view = new UserSelectionView();
        view.DataContext = DataContext;
        userVM.MainFrame = MainFrame; // Mainframe aus XAML in ViewModel durchreichen
        MainFrame.Navigate(view);
      }
      else if (DataContext is AdminViewModel adminVM)
      {
        var view = new AdminSelectionView();
        view.DataContext = DataContext;
        adminVM.MainFrame = MainFrame; // Mainframe aus XAML in ViewModel durchreichen
        MainFrame.Navigate(view);
      }
    }
  }
}
