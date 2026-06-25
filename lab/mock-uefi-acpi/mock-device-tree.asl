DefinitionBlock ("mock.aml", "SSDT", 2, "DEKASIG", "MOCKDEV", 0x1000)
{
    Scope (_SB)
    {
        Device (MDEV)
        {
            Name (_HID, "MOCK0001")
            Name (_CID, "MOCK0001")
            Name (_DDN, "Mock Secure Boot Lab Device")

            Method (_STA, 0, NotSerialized)
            {
                Return (0x0F)
            }

            Method (_DSM, 4, Serialized)
            {
                Return (Buffer () { 0x00 })
            }
        }
    }
}
