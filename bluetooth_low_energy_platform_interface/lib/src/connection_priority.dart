/// ConnectionPriority
enum ConnectionPriority {
  /// Connection parameter update - Use the connection parameters recommended by
  /// the Bluetooth SIG. This is the default value if no connection parameter
  /// update is requested.
  balanced,

  /// Connection parameter update - Request a high priority, low latency connection.
  /// An application should only request high priority connection parameters to
  /// transfer large amounts of data over LE quickly. Once the transfer is complete,
  /// the application should request CONNECTION_PRIORITY_BALANCED connection
  /// parameters to reduce energy use.
  high,

  /// Connection parameter update - Request low power, reduced data rate connection
  /// parameters.
  lowPower,

  /// Connection parameter update - Request the priority preferred for Digital
  /// Car Key for a lower latency connection. This connection parameter will
  /// consume more power than CONNECTION_PRIORITY_BALANCED, so it is recommended
  /// that apps do not use this unless it specifically fits their use case.
  dck,
}
