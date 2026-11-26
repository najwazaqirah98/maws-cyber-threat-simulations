# MAWS Cyber-Threat Simulations (MATLAB)

MATLAB simulations of cyber and electronic threats against a Missile Approach Warning System (MAWS), together with simple detection and mitigation approaches. All signals are synthetic (sine waves standing in for an IR detection signal), so this repository is for learning and prototyping, not for operational use.

## Repository structure

| Folder | Script | What it does |
|---|---|---|
| `jamming/` | `jam_basic.m` | Gaussian noise jamming, recovered with a low-pass filter |
| | `ai_jam.m` | Chirp + noise jamming, mitigated with wavelet denoising and an LMS adaptive filter |
| | `deeplearn_jam.m` | Neural-network jamming detection from energy and entropy features |
| `spoofing/` | `spoof_basic.m` | False-signal injection, detected by energy/entropy thresholds and spectrum view |
| | `ai_spoof.m` | Spoofing detection plus LMS-based suppression |
| | `deeplearn_spoof.m` | Neural-network spoofing detection |
| `dos/` | `dos_maws.m` | Pulse-overload DoS, threshold and neural-network detection, LMS filtering |
| `software_vulnerability/` | `software_vul.m` | Data corruption and overload in a signal-processing chain, with anomaly detection |
| | `adv_software_vul.m` | Adds spectral-difference features and a larger network |
| `secure_communication/` | `secure_comm.m` | Combined jamming, spoofing and DoS on a link, detection, and an XOR encryption demo |

## Requirements

- MATLAB (R2021a or later recommended)
- Signal Processing Toolbox (`chirp`, `square`, `periodogram`, `lowpass`)
- Wavelet Toolbox (`wentropy`, `wdenoise`)
- DSP System Toolbox (`dsp.LMSFilter`)
- Deep Learning Toolbox (`trainNetwork`, `featureInputLayer`)

## Usage

Open MATLAB, change into the folder of interest, and run a script by name, for example:

```matlab
cd jamming
ai_jam
```

Each script generates its signals, applies the attack, runs detection or mitigation, and plots the results. Noise is random, so results vary slightly between runs. Add `rng(1)` at the top of a script for repeatable output.

## Limitations

- Signals are idealised single-tone sine waves, not real IR or sensor data.
- The neural-network scripts train on repeated copies of one "normal" and one "attack" feature vector, and are tested on the same features. They demonstrate the pipeline, not real detection performance. Realistic use would need many randomised samples and a separate test set.
- Some detectors (`spoof_basic.m`, `ai_spoof.m`) use placeholder thresholds rather than a trained classifier.
- The XOR demo in `secure_comm.m` only illustrates encrypt/decrypt flow. It is not AES and is not secure.

## Disclaimer

Educational and research use only. These scripts model generic signal-level effects and contain no real system data or exploit code.

## License

Add a license of your choice (for example MIT) as `LICENSE`.

## Author

Najwa Zaqirah Taufik
