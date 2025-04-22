import HotKey
import Carbon

extension Key {
    init?(string: String) {
        switch string {
        case "A": self = .a
        case "B": self = .b
        case "C": self = .c
        case "D": self = .d
        case "E": self = .e
        case "F": self = .f
        case "G": self = .g
        case "H": self = .h
        case "I": self = .i
        case "J": self = .j
        case "K": self = .k
        case "L": self = .l
        case "M": self = .m
        case "N": self = .n
        case "O": self = .o
        case "P": self = .p
        case "Q": self = .q
        case "R": self = .r
        case "S": self = .s
        case "T": self = .t
        case "U": self = .u
        case "V": self = .v
        case "W": self = .w
        case "X": self = .x
        case "Y": self = .y
        case "Z": self = .z
        case "0": self = .zero
        case "1": self = .one
        case "2": self = .two
        case "3": self = .three
        case "4": self = .four
        case "5": self = .five
        case "6": self = .six
        case "7": self = .seven
        case "8": self = .eight
        case "9": self = .nine
        case "F1": self = .f1
        case "F2": self = .f2
        case "F3": self = .f3
        case "F4": self = .f4
        case "F5": self = .f5
        case "F6": self = .f6
        case "F7": self = .f7
        case "F8": self = .f8
        case "F9": self = .f9
        case "F10": self = .f10
        case "F11": self = .f11
        case "F12": self = .f12
        default: return nil
        }
    }
}
