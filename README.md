# Lirum.Network

![alt tag](http://www.rogeriohirooka.com/wp-content/uploads/2016/09/Network.png)

This is an implementation of netstat, used in Lirum Device Info - that lists all active connections. 
Netstat (network statistics) is a command-line network utility tool that displays network connections for TCP (both incoming and outgoing), routing tables, and a number of network interface (network interface controller or software-defined network interface) and network protocol statistics. It is available on Unix-like operating systems including OS X, Linux, Solaris, and BSD, and is available on Windows NT-based operating systems including Windows XP, Windows Vista, Windows 7, Windows 8 and Windows 10.
For iOS however, there wasn't a native implementation, so we had to adapt the code of netstat to work with Objective-C, and put it into a library. The implementation runs on iPhones, iPod Touches and iPads prior to iOS 10 (since the iOS 10 betas, this code does not returns the active connections anymore).

[Link to YouTube - Lirum Device Info - Network Connections](https://www.youtube.com/watch?v=5m5szRjSweQ)


To use it, just add the static library on Linked Frameworks and Libraries, and then call the initializers:

    Lirum_Network * l = [[Lirum_Network alloc] init];
    NSMutableDictionary *m = [l getConnections];
    
    [Lirum_Network initializeNetworkElements];

    NSLog(@"Connections: %@", m);
    
    NSLog(@"WWAN IP: %@", [Lirum_Network getWWanIP]);
    NSLog(@"Wifi IP: %@", [Lirum_Network getWifiIP]);
    
    NSString *wwanIP = [Lirum_Network getWWanIP];
    NSString *wifiIP = [Lirum_Network getWifiIP];
    
    [txtOutput setText: [NSString stringWithFormat:@"WWAN IP: %@\nWifi IP: %@\nConnections:\n%@", wwanIP, wifiIP, m]];


Running on an iPhone 6S Plus - iOS 9.3.5:
![alt tag](http://www.rogeriohirooka.com/wp-content/uploads/2016/09/iOS-netstat.png)

The return from Lirum_Network getConnections is a NSDictionary grouped by Protocol Type (IPv6, IPv4, TCP, UDP, etc). 
Sample return in plaintext:

    "IP6.TCP" =     (
                {
            local = "fe80:8::1c70:97ae:bfc8:c1a0.61731";
            "local.namedport" = "fe80:8::1c70:97ae:bfc8:c1a0.61731";
            proto = "tcp6 ";
            recvq = "     0";
            remote = "fe80:8::26a0:74ff:feea:538.57527";
            "remote.namedport" = "fe80:8::26a0:74ff:feea:538.57527";
            sendq = "     0";
            state = ESTABLISHED;
        },
                {
            local = "fe80:8::1c70:97ae:bfc8:c1a0.61730";
            "local.namedport" = "fe80:8::1c70:97ae:bfc8:c1a0.61730";
            proto = "tcp6 ";
            recvq = "     0";
            remote = "fe80:8::26a0:74ff:feea:538.57477";
            "remote.namedport" = "fe80:8::26a0:74ff:feea:538.57477";
            sendq = "     0";
            state = ESTABLISHED;
        },
                {
            local = "fe80:b::db25:5b8:d6c4:b265.1025";
            "local.namedport" = "fe80:b::db25:5b8:d6c4:b265.blackjac";
            proto = "tcp6 ";
            recvq = "     0";
            remote = "fe80:b::f39f:9239:85b6:5d1e.60492";
            "remote.namedport" = "fe80:b::f39f:9239:85b6:5d1e.60492";
            sendq = "     0";
            state = ESTABLISHED;
        },
                {
            local = "fe80:b::db25:5b8:d6c4:b265.3555";
            "local.namedport" = "fe80:b::db25:5b8:d6c4:b265.razor";
            proto = "tcp6 ";
            recvq = "     0";
            remote = "fe80:b::f39f:9239:85b6:5d1e.1025";
            "remote.namedport" = "fe80:b::f39f:9239:85b6:5d1e.1025";
            sendq = "     0";
            state = ESTABLISHED;
        },
                {
            local = "fe80:b::db25:5b8:d6c4:b265.1025";
            "local.namedport" = "fe80:b::db25:5b8:d6c4:b265.blackjac";
            proto = "tcp6 ";
            recvq = "     0";
            remote = "fe80:b::f39f:9239:85b6:5d1e.36540";
            "remote.namedport" = "fe80:b::f39f:9239:85b6:5d1e.36540";
            sendq = "     0";
            state = ESTABLISHED;
        },
                {
            local = "fe80:b::db25:5b8:d6c4:b265.1025";
            "local.namedport" = "fe80:b::db25:5b8:d6c4:b265.blackjac";
            proto = "tcp6 ";
            recvq = "     0";
            remote = "fe80:b::f39f:9239:85b6:5d1e.51787";
            "remote.namedport" = "fe80:b::f39f:9239:85b6:5d1e.51787";
            sendq = "     0";
            state = ESTABLISHED;
        },
                {
            local = "fe80:b::db25:5b8:d6c4:b265.1025";
            "local.namedport" = "fe80:b::db25:5b8:d6c4:b265.blackjac";
            proto = "tcp6 ";
            recvq = "     0";
            remote = "fe80:b::f39f:9239:85b6:5d1e.47541";
            "remote.namedport" = "fe80:b::f39f:9239:85b6:5d1e.47541";
            sendq = "     0";
            state = ESTABLISHED;
        },
                {
            local = "fe80:b::db25:5b8:d6c4:b265.62475";
            "local.namedport" = "fe80:b::db25:5b8:d6c4:b265.62475";
            proto = "tcp6 ";
            recvq = "     0";
            remote = "fe80:b::f39f:9239:85b6:5d1e.1025";
            "remote.namedport" = "fe80:b::f39f:9239:85b6:5d1e.1025";
            sendq = "     0";
            state = ESTABLISHED;
        },
                {
            local = "fe80:b::db25:5b8:d6c4:b265.1024";
            "local.namedport" = "fe80:b::db25:5b8:d6c4:b265.1024";
            proto = "tcp6 ";
            recvq = "     0";
            remote = "fe80:b::f39f:9239:85b6:5d1e.1024";
            "remote.namedport" = "fe80:b::f39f:9239:85b6:5d1e.1024";
            sendq = "     0";
            state = ESTABLISHED;
        },
                {
            local = "*.62078";
            "local.namedport" = "*.62078";
            proto = "tcp6 ";
            recvq = "     0";
            remote = "*.*";
            "remote.namedport" = "*.*";
            sendq = "     0";
            state = LISTEN;
        },
                {
            local = "::1.8021";
            "local.namedport" = "::1.intu-ec-";
            proto = "tcp6 ";
            recvq = "     0";
            remote = "*.*";
            "remote.namedport" = "*.*";
            sendq = "     0";
            state = LISTEN;
        }
    );
    "IP6.UCP" =     (
                {
            local = "*.5353";
            "local.namedport" = "*.5353";
            proto = "ucp6 ";
            recvq = "     0";
            remote = "*.*";
            "remote.namedport" = "*.*";
            sendq = "     0";
        }
    );
