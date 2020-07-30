class ChartModel{
  final String name;
  final String message;
  final String lastseen;
  final String time;
  final String profileUrl;

  ChartModel({this.name, this.message, this.lastseen, this.time, this.profileUrl});
  
}

final List<ChartModel> items =[
  ChartModel(name: 'Usman',message: 'Hello, How are you?', lastseen: 'Last Seen today At 12:05Am', time: '10:39',profileUrl: 'https://s3.amazonaws.com/uifaces/faces/twitter/jarjan/128.jpg'),
  ChartModel(name: 'Mohsin Sapra ',message: 'I am Fine.' , lastseen: 'Last Seen today At 11:10pm', time: 'Feb 12',profileUrl: 'https://s3.amazonaws.com/uifaces/faces/twitter/steynviljoen/128.jpg'),
  ChartModel(name: 'Ali Shah',message: 'See you at 10.' , lastseen: 'Last Seen Friday At 11:05pm', time: '12:12',profileUrl: 'https://s3.amazonaws.com/uifaces/faces/twitter/gregrwilkinson/128.jpg'),
  ChartModel(name: 'Haider Ali',message: 'I miss you.', lastseen: 'Last Seen Friday At 10:05pm', time: '6:11',profileUrl: 'https://s3.amazonaws.com/uifaces/faces/twitter/bolzanmarco/128.jpg'),
  ChartModel(name: 'Yahya Hassan ',message: 'Coming to you.', lastseen: 'Last Seen Thursday At 09:05pm', time: 'Jan 1',profileUrl: 'https://s3.amazonaws.com/uifaces/faces/twitter/trueblood_33/128.jpg'),
  ChartModel(name: 'Ibrahim Yaqoob',message: 'Pick me up at 11.', lastseen: 'Last Seen Monday At 12:15pm', time: '4:00',profileUrl: 'https://s3.amazonaws.com/uifaces/faces/twitter/osmanince/128.jpg'),
  ChartModel(name: 'Abdullah Mir',message: 'Excuse me?' , lastseen: 'Last Seen Sunday At 01:05Am', time: 'Dec 10',profileUrl: 'https://s3.amazonaws.com/uifaces/faces/twitter/nastya_mane/128.jpg'),
  ChartModel(name: 'Amina ',message: 'I am doing good. What about you dear?', lastseen: 'Last Seen Sunday At 12:05pm', time: '4:30',profileUrl: 'https://s3.amazonaws.com/uifaces/faces/twitter/notbadart/128.jpg'),
  ChartModel(name: 'Jhon',message: 'Hi', lastseen: 'Last Seen Sunday At 04:15Am', time: '6:00',profileUrl: 'https://s3.amazonaws.com/uifaces/faces/twitter/marcobarbosa/128.jpg'),
  ChartModel(name: 'Stuart',message: 'See you Take Care.', lastseen: 'Last Seen Sunday At 10:10Am', time: '5:12',profileUrl: 'https://s3.amazonaws.com/uifaces/faces/twitter/moynihan/128.jpg')
];