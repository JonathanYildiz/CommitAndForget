﻿using System.Text;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using CommitAndForget.ViewModel;

namespace CommitAndForget
{
  public partial class LoginView : Window
  {
    public LoginView()
    {
      InitializeComponent();
      DataContext = new LoginViewModel();
    }
  }
}