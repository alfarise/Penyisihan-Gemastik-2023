from Crypto.Util.number import *

e = 65537
c = 84024814852788124466425703643863038749481647370871639089654387542036643094716882068963882238496325769187878841775880081279152499243027962801549637300718551708561273294208652726640622690307777302333680477067048191391930158103357680194404771799199270457029205340289309827037753672155563351056992825762854051224
n = 158463604064988674814039489303941776312791739197627574932768489648690514396703416035754401039816044989153946047961788657502924899489831181881976797925405205879265356891684604165414639744668756045525079746390221907286699345190568138908374561952476963068186895955907054769899744946840855438948702842692818992193
modd = 28380446321095327045197943237561249132818639849632383597957781139459442976484022092235551323350873442219988496936317243060695903464196236518499415107693912425146869970931590379094106285244897949112170793149963425649014239104215833842814257009714057533568025678694679554857780851646426228532250750372305903959916291671627585809053461591194382116337570074638325015114805604072385544025035377829638386785120688334551740081467841719585730908022128079866130687361608669542661116817147325164173681733966300168129858129906169569291487066119040715366582183828675478522478096526885343420675985370458086475314154595337857476899
hint_1 = 81813119979744357303763165097277937958832393933373338098275076650301553027527996054129758821806150335067485819738432997780039994547616390541448175462514726116257489583525965719006176585106201077096492640208154851064083081914900991051522865322141804472360190857895241232523630699727605379452784521665518271731063633536742217058852820964499079832842067879422070222355944056878164298442422556194511015260428242217865176134094577687217869008146710683271174759372846052837009048977507229936211604102332267749999555281976244071174858943184520818940571841826590657426078269047245626706453929118608324689256506522595415935025982865082986683254070145179665083950019654924243468765457223868455752542625019204956397050465933928837910298798965289994071762528071761825840693055585978
hint_2 = 24493582264907279335481329875575440353771879586343265256927757716882253910214971560078538602292042215303641369721266133918409047696481779931357018151066178282930726895277628523383906367631163668970040507100244850476271359258325348954647945880467468358330798152920888613042194071469780128725444710685338483128503270497115385725275752638123358833863381280612973892420606885175774206337366494751172133790352672634093339379010889834693088370809714654514714408038790522034408079232046483910339594196135924972214717701099137107173794324623583851958557523170222491515471205360596695102487852539938321764724732541585538200780

F.<x> = GF(modd)[]
sols = factor(x^4 - hint_2)

for sol in sols:
    hidden_val = int(sol[0][0])
    print(f'Try to use {hidden_val} as the hidden_val')
    print(f'Try to recover z3')
    rand_1_mod_n = (hidden_val % n)
    found = False
    for k in range(10000):
        # The value that we got is rand_1 % n, and rand_1 is larger than n. So, the real rand_1 value is actually
        # in form of rand_1 = rand_1_mod_n + k*n
        # However, it is only slighty larger than n, so we can bruteforce the k value, which means
        # z3 = (hidden_val - (rand_1_mod_n + k*n)) // n
        rand_1 = rand_1_mod_n + k*n
        curr_z3 = (hidden_val - rand_1) // n
        print(f'{curr_z3 = }, predicted {k = }')  

        # Perform lattice reduction again with the hint_1. We hope that after reduction,
        # one of the vector will be (-rand_2, z2*s, z1*s).
        s = 2 ** (1024 - 512)
        m = matrix( 
            [ 
                [(curr_z3**8)     , 1 * s, 0    ],
                [(0x1337 * n), 0    , 1 * s],
                [-hint_1     , 0    , 0    ],
            ] 
        ) 
        L = m.LLL()
        for vector in L:
            if (vector[1] // s).nbits() == 512 and is_prime(vector[1] // s):
                z2 = vector[1] // s
                z1 = n // z2
                break
            elif (vector[2] // s).nbits() == 512 and is_prime(vector[2] // s):
                z1 = vector[2] // s
                z2 = n // z1
                break
        try:
            print(f'{z1 = }')
            print(f'{z2 = }')
            print(f'Assert z1*z2 == n: {z1*z2 == n}')
            d = inverse_mod(e, (z1-1)*(z2-1))
            m = pow(c, d, n)
            print(f'{m = }')
            flag = long_to_bytes(int(m))
            print(f'Flag: {flag.decode()}')
            print()
            if b'gemastik' in flag:
                found = True
        except:
            continue
        if found:
            break
    if found:
        break
